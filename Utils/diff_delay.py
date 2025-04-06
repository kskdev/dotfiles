# -*- coding: utf-8 -*-
"""
相互相関取って音声データの時間合わせをする
"""

import os

import numpy as np
import librosa
import soundfile as sf


def load_soundfile(sound_path: str, sample_rate=None) -> tuple[np.ndarray, int]:
    """ 音声ファイルを読み込む (MP4等もFFmpegがあれば対応可能) """
    # librosa の仕様上mp4などは，audioread を代わりに利用すると，Warningが出る．
    import warnings
    warnings.simplefilter("ignore", UserWarning)
    warnings.simplefilter("ignore", FutureWarning)  # backendのaudioreadは将来廃止

    sample_np, sample_rate = librosa.load(sound_path, sr=sample_rate, mono=False)
    print(f"[load_soundfile()] {sample_rate=} {sample_np.shape=} {sound_path=}")
    return sample_np, sample_rate


def compute_correlation(sample_A:np.ndarray, sample_B:np.ndarray, sample_rate:int, max_sec=None) -> tuple[int, float]:
    """ 2つのモノラル音声の時間差を計算 (sample_A基準) """
    # 入力音声チェック
    assert sample_A.ndim==2,"sampleA shape should be [ch, sample]"
    assert sample_B.ndim==2,"sampleB shape should be [ch, sample]"
    ch_A, len_A = sample_A.shape
    ch_B, len_B = sample_B.shape
    assert len_A>0,"length is zero..."
    assert len_B>0,"length is zero..."

    # 切り出し指定がある場合，長さ調整
    is_slice  = max_sec is not None
    slice_len = int(sample_rate*max_sec) if is_slice else len_A
    min_len = min(len_A,len_B)
    min_len = min(min_len, slice_len) if is_slice else min_len
    sample_A = sample_A[0,:min_len]
    sample_B = sample_B[0,:min_len]
    print(f"[compute_correlation()] {sample_A.shape=}")
    
    # 相互相関
    print(f"[compute_correlation()] Compute start...")
    correlation = np.correlate(sample_A, sample_B, mode="full")
    peak_index = np.argmax(correlation)
    diff_pt = peak_index - (len(sample_B) - 1) # Bの遅延量
    diff_ms = (diff_pt / sample_rate) * 1000.0
    print(f"[compute_correlation()] Diff: {diff_pt}[pt]  {diff_ms:.2f}[ms]")
    return int(diff_pt), diff_ms


def write(samples:np.ndarray, sample_rate:int, diff_len:int, outpath:str):
    """ 時間差(サンプル数)に基づき音声配列を調整し書き出す """
    # librosaは，ch first だが， soundfileは sample first なので注意．

    assert samples.ndim==2, f"samples.ndim should be 2. {samples.ndim=}"
    _ch, _length = samples.shape
    assert _ch<_length, f"samples.shape should be [ch,sapmles]. {samples.shape=}"
    sample_T = samples.T  # [ch, samples] > [samples, ch]
    adjusted_samples = np.copy(sample_T)

    if diff_len > 0: # パディング
        print(f"[write()] Zero padding start with {diff_len}[pt].")
        _pad_shape = (diff_len, _ch)
        _padding = np.zeros(_pad_shape, dtype=sample_T.dtype)
        adjusted_samples = np.concatenate((_padding, sample_T), axis=0)
    elif diff_len < 0: # トリミング
        trim_amount = abs(diff_len)
        print(f"[write()] Trimming start by {trim_amount} samples.")
        adjusted_samples = sample_T[trim_amount:,:]
    else:
        print(f"[write()] No processing")

    if _ch==2:
        sf.write(outpath, adjusted_samples[:,:], sample_rate, subtype="PCM_16")
    else:
        sf.write(outpath, adjusted_samples[:,0], sample_rate, subtype="PCM_16")
    print(f"[write()] Write. output path: {outpath}")


if __name__ == "__main__":
    # 時間合わせ元:A 合わせ先:B
    input_path_A = "sound_A.wav"
    input_path_B = "sound_B.wav"
    output_path  = "./processedB.wav"
    target_sec = 20  # default:None

    # 読み込み
    sampleA,rateA = load_soundfile(input_path_A,None)
    sampleB,rateB = load_soundfile(input_path_B,rateA)
    # 相互相関
    diff_pt,_ = compute_correlation(sampleA,sampleB,rateA, target_sec)
    # 書き出し
    write(sampleB, rateA, diff_pt, output_path)
    print("Done.")
