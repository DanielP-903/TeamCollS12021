using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundManager : MonoBehaviour
{
	public static SoundManager Instance;

	[Tooltip("Play music clip when start")]
	public AudioClip musicsMenu;
	[Range(0, 1)]
	public float musicMenuVolume = 0.5f;
	public AudioClip musicsGame;
	[Range(0, 1)]
	public float musicsGameVolume = 0.5f;

	[Tooltip("Place the sound in this to call it in another script by: SoundManager.PlaySfx(soundname);")]
	public AudioClip soundClick;

	public int scenevalue;

	public AudioSource musicAudio;
	public AudioSource uiFx;
	public AudioSource soundFx;

	public static float MusicVolume
	{
		set { Instance.musicAudio.volume = value; }
		get { return Instance.musicAudio.volume; }
	}
	public static float SoundVolume
	{
		set { Instance.soundFx.volume = value; }
		get { return Instance.soundFx.volume; }
	}

	public static float UiVolume
	{
		set { Instance.uiFx.volume = value; }
		get { return Instance.uiFx.volume; }
	}
	// Use this for initialization
	void Awake()
	{
		Instance = this;
		musicAudio.loop = true;

	
	}
	void Start()
	{
		//		//Check auido and sound
		//		if (!GlobalValue.isMusic)
		//			musicAudio.volume = 0;
		//		if (!GlobalValue.isSound)
		//			soundFx.volume = 0;
		if (scenevalue == 1)
		{
			PlayMusic(musicsMenu, musicMenuVolume);
			musicAudio.volume = musicMenuVolume;
		}
		else if (scenevalue == 2)
		{
			PlayMusic(musicsGame, musicsGameVolume);
			musicAudio.volume = musicsGameVolume;

		}
		else if(scenevalue==3)
        {
			PlayMusic(musicsGame, musicsGameVolume);
			musicAudio.volume = musicsGameVolume;
        }

	}


	public static void PlaySfx(AudioClip clip, float volume)
	{
		Instance.PlaySound(clip, Instance.soundFx, volume);
	}

	public static void PlayUifx(AudioClip clip, float volume)
	{
		Instance.PlaySound(clip, Instance.uiFx, volume);
	}

	public static void PlayMusic(AudioClip clip)
	{
		Instance.PlaySound(clip, Instance.musicAudio);
	}

	public static void PlayMusic(AudioClip clip, float volume)
	{
		Instance.PlaySound(clip, Instance.musicAudio, volume);
	}

	private void PlaySound(AudioClip clip, AudioSource audioOut)
	{
		if (clip == null)
		{
			//			Debug.Log ("There are no audio file to play", gameObject);
			return;
		}

		if (audioOut == musicAudio)
		{
			audioOut.clip = clip;
			audioOut.Play();
		}
		else
			audioOut.PlayOneShot(clip, SoundVolume);
	}

	private void PlaySound(AudioClip clip, AudioSource audioOut, float volume)
	{
		if (clip == null)
		{
			//			Debug.Log ("There are no audio file to play", gameObject);
			return;
		}

		if (audioOut == musicAudio)
		{
			audioOut.clip = clip;
			audioOut.Play();
		}
		else
			audioOut.PlayOneShot(clip, SoundVolume * volume);
	}
}