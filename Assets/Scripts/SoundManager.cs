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

	public AudioClip track2;
	[Range(0, 1)]
	public float trackVolume2 = 0.5f;
	public AudioClip track3;
	[Range(0, 1)]
	public float trackVolume3 = 0.5f;

	[Tooltip("Place the sound in this to call it in another script by: SoundManager.PlaySfx(soundname);")]

	public int scenevalue;

	public AudioSource musicAudio;
	public AudioSource uiFx;
	public AudioSource soundFx;
	public AudioClip[] clips;
	int clipOrder=0;
	public bool istrack2;
	public bool istrack3;

	private DayAndNightCycle daynight;

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
		//musicAudio.loop = true;

	
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
		if(scenevalue==2)
        {
		//	PlayMusic(musicsGame, musicsGameVolume);
			musicAudio.volume = musicsGameVolume;
			daynight = GameObject.FindObjectOfType<DayAndNightCycle>();
        }
	}

	void Update()
	{
		if (scenevalue == 2)
		{
			if (daynight.time < 0.5f)
			{
				if (!musicAudio.isPlaying)
				{
					musicAudio.clip = GetNextClip();
					musicAudio.Play();
				}
			}
			if (daynight.time > 0.5f)
			{
				if (!istrack2)
				{
					istrack2 = true;
					musicAudio.clip = GetNextClip();
					musicAudio.Play();
				}
			}
			if (daynight.time > 1f)
			{
				if (!istrack3)
				{
					istrack3 = true;
					musicAudio.clip = GetNextClip();
					musicAudio.Play();
				}
			}
		}
	}

	public void OffSound()
    {
		AudioListener.pause = true;
		musicAudio.Pause();
    }

	public void OnSound()
    {
		AudioListener.pause = false;
		musicAudio.Play();
    }



	// function to get the next clip in order, then repeat from the beginning of the list.
	private AudioClip GetNextClip()
	{
		if (clipOrder >= clips.Length - 1)
		{
			clipOrder = 0;
		}
		else
		{
			clipOrder += 1;
		}
		return clips[clipOrder];
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