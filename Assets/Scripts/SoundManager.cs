using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

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

	public int scenevalue;

	public AudioSource musicAudio;
	public AudioSource uiFx;
	public AudioSource soundFx;
	public AudioSource matchFx;
	public AudioClip[] clips;
	int clipOrder=0;
	public bool istrack2;
	public bool istrack3;
	public Slider volumeslider;

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

	public static float MatchVolume
	{
		set { Instance.matchFx.volume = value; }
		get { return Instance.matchFx.volume; }
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
	//	if (PlayerPrefs.GetInt("Muted", 0) == 0)
	//	{
	//		PlayerPrefs.SetInt("Muted", 1);
	//	}
	//	else
		
			//		PlayerPrefs.SetInt("Muted", 0);
			//	}
			if (PlayerPrefs.HasKey("musicvolume"))
			{
				PlayerPrefs.SetFloat("musicvolume", 1);
				Load();
			}
			else
			{
				Save();
			}

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
			if(daynight.time>0.45f && daynight.time<0.5f)
            {
				StartCoroutine(CurrentSong());
			}
			if(daynight.time>0.5f && daynight.time<0.55f)
            {
				StartCoroutine(NextSong());
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
			if(daynight.time>0.95f && daynight.time<1f)
            {
				StartCoroutine(CurrentSong());
            }
			if(daynight.time>1f && daynight.time<1.5f)
            {
				StartCoroutine(NextSong());
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
	//	if (PlayerPrefs.GetInt("Muted", 0) == 0)
	//	{
			AudioListener.volume = 0;
			PlayerPrefs.SetInt("Muted", 1);
			PlayerPrefs.Save();
			
	//	}
    }

	public void OnSound()
    {
	//	if (PlayerPrefs.GetInt("Muted", 0) == 1)
	//	{
			AudioListener.volume = 1;
			PlayerPrefs.SetInt("Muted", 0);
			PlayerPrefs.Save();
			
	//	}
	}

	public void ChangeVolume()
	{
		AudioListener.volume = volumeslider.value;
	}

	public void Load()
	{
		volumeslider.value = PlayerPrefs.GetFloat("musicvolume");
	}

	public void Save()
	{
		PlayerPrefs.SetFloat("musicvolume", volumeslider.value);
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
	public static void PlayMatchfx(AudioClip clip, float volume)
	{
		Instance.PlaySound(clip, Instance.matchFx, volume);
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

	IEnumerator CurrentSong()
    {
		float currentTime = 0;
		float start = musicAudio.volume;
		float duration = 3f;
		float target = 0f;
		while (currentTime < duration)
		{
			currentTime += Time.deltaTime;
			musicAudio.volume = Mathf.Lerp(start, target, currentTime / duration);
			yield return null;
		}
		yield break;
	}

	IEnumerator NextSong()
    {
	float current = 0;
	float nextsongstart = musicAudio.volume;
	float songduration = 5f;
	float targetvolume = 0.3f;
	while (current < songduration)
	{
		current += Time.deltaTime;
		musicAudio.volume = Mathf.Lerp(nextsongstart, targetvolume, current / songduration);
		//Debug.Log("still running");
		yield return null;
	}
	yield break;
}
}