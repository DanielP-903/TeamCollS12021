using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainMenuCamera : MonoBehaviour {

	public GameObject gameStartedPosition;
	public GameObject optionSelectPosition;

	private bool reached_GameStartedPosition;

	private bool reached_OptionSelectPosition = true;
	private bool canMove;
	private bool backToMainMenu;

	// EASIER WAY
	private List<GameObject> positions = new List<GameObject>();
	// EASIER WAY

	void Awake() {
		positions.Add (gameStartedPosition);
	}

	void Update () {
//		MoveToGameStartedPosition ();
//		MoveToCharacterSelectMenu ();
//
//		MoveBackToMainMenu ();

		MoveToPosition ();
	}

	void MoveToPosition() {
		if (positions.Count > 0) {

			transform.position = Vector3.Lerp (transform.position, 
				positions[0].transform.position, 1f * Time.deltaTime);

			transform.rotation = Quaternion.Lerp (transform.rotation,
				positions[0].transform.rotation, 1f * Time.deltaTime);
		}
	}

	public void ChangePosition(int index) {
		positions.RemoveAt (0);

		if (index == 0) {
			positions.Add (gameStartedPosition);
		} else {
			positions.Add (optionSelectPosition);
		}
	}

	void MoveToGameStartedPosition() {
		if (!reached_GameStartedPosition) {
			if (Vector3.Distance (transform.position, gameStartedPosition.transform.position) < 0.2f) {
				reached_GameStartedPosition = true;
				canMove = true;
			}
		}

		if (!reached_GameStartedPosition) {
			transform.position = Vector3.Lerp (transform.position, gameStartedPosition.transform.position,
				1f * Time.deltaTime);
			transform.rotation = Quaternion.Lerp (transform.rotation, gameStartedPosition.transform.rotation,
				1f * Time.deltaTime);
		}
	}

	void MoveToOptionsMenu() {
		if (!reached_OptionSelectPosition) {
			transform.position = Vector3.Lerp (transform.position, 
				optionSelectPosition.transform.position,
				1f * Time.deltaTime);
			
			transform.rotation = Quaternion.Lerp (transform.rotation, 
				optionSelectPosition.transform.rotation,
				-1f * Time.deltaTime);
		}

		if (!reached_OptionSelectPosition) {
			if (Vector3.Distance (transform.position, optionSelectPosition.transform.position) < 0.2f) {
				reached_OptionSelectPosition = true;
				canMove = true;
			}
		}
	}

	void MoveBackToMainMenu() {
		if (backToMainMenu) {
			if (Vector3.Distance (transform.position, gameStartedPosition.transform.position) < 0.2f) {
				backToMainMenu = false;
				canMove = true;
			}
		}

		if (backToMainMenu) {
			transform.position = Vector3.Lerp (transform.position, gameStartedPosition.transform.position,
				1f * Time.deltaTime);
			transform.rotation = Quaternion.Lerp (transform.rotation, gameStartedPosition.transform.rotation,
				1f * Time.deltaTime);
		}
	}

	public bool ReachedOptionsPosition {
		get { return reached_OptionSelectPosition; }
		set { reached_OptionSelectPosition = value; }
	}

	public bool CanMove {
		get { return canMove; }
		set { canMove = value; }
	}

	public bool BackToMainMenu {
		get { return backToMainMenu; }
		set { backToMainMenu = value; }
	}

} // class






































