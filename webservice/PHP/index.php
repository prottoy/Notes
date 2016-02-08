<?php
// MARK :- THIS CLASS WILL GIVE JSON REPONSES
header('Content-Type: application/json');

// MARK :- DATABASE CONNECTION CREDENTIALS
$servername = "localhost";
$username = "root";
$password = "root";
$dbname = "Notes";

/**
* Notes class
*/
class Notes
{
	var $servername;
	var $username;
	var $password;
	var $dbname;

	var $conn;

	function __construct($_servername, $_username, $_password, $_dbname)
	{
		$this -> servername =  $_servername;
		$this -> username = $_username;
		$this -> password = $_password;
		$this -> dbname = $_dbname;
	}

	function enableDebug(){
		//Display all errors
		ini_set("display_errors", "1");
		error_reporting(E_ALL);
	}

	function connectToDatbase(){
		// Create connection
		$this-> conn = new mysqli($this-> servername, $this-> username, $this-> password, $this-> dbname);
		// Check connection
		if ($this-> conn->connect_error) {
			die("Connection failed: " . $this-> conn->connect_error);
		} 
	}

	function closeDatabaseConnection(){
		$this-> conn->close();
	}

	function service(){
		$this->connectToDatbase();

		$method = $_SERVER['REQUEST_METHOD'];
		if ($method == 'POST') {
    		// Method is POST
			if ( !empty($_POST["delete"])) {
				$this-> deleteNote(intval($_POST["delete"]));
			}
			else if( !empty($_POST["title"])&& !empty($_POST["description"])) {
				$this-> saveNote(addslashes($_POST["title"]), addslashes($_POST["description"]));
			}

		} elseif ($method == 'GET') {
    		// Method is GET
			$this-> retrieveAllNotes();
		} elseif ($method == 'PUT') {
    		// Method is PUT
    		// Update data 
			parse_str(file_get_contents("php://input"),$post_vars);

			$note_id = $post_vars["id"];
			$title = $post_vars["title"];
			$description = $post_vars["description"];

			$this -> updateNote($note_id, $title, $description);
		} 
		else {
			// Method is UNKNOWN
    		$data = array('Status' => 'Failure', 'message'=> 'unknown method');
    		echo json_encode($data);
		}

		$this -> closeDatabaseConnection();
	}


	function retrieveAllNotes(){
		$sql = "SELECT * FROM notes";
		$result = $this-> conn->query($sql);
		$data = array();

		if ($result->num_rows > 0) {
    		// output data of each row
			while($row = $result->fetch_assoc()) {
				array_push($data, $row);
			}
		} 

		echo json_encode($data);
	}

	function saveNote($_title, $_description){
		$note = array('title' => $_title , 'description' => $_description);

		//This will delete the note with id
		$sql = "INSERT INTO notes (title,note) VALUES ('$_title', '$_description');";

		if ($this-> conn->query($sql)) {
			$this-> retrieveAllNotes();
		}else{
			$this-> retrieveAllNotes();
		}

	}

	function deleteNote($_id){
		//This will delete the note with id
		$sql = "DELETE FROM notes WHERE id = '$_id'";
		if ($this-> conn->query($sql)) {

			$data = array('Status' => 'Success', 'message'=> 'deleted Successfully', 'debug'=> $sql);
			echo json_encode($data);
		}else{
			$data = array('Status' => 'Failure', 'message'=> 'delete failure', 'debug'=> $sql);
			echo json_encode($data);
		}

		
	}

	function updateNote($_id, $_title, $_description){
		//This will delete the note with id
		$sql = "UPDATE notes SET title='$_title',note='$_description' WHERE id='$_id';";

		if ($this-> conn->query($sql)) {
			$this-> retrieveAllNotes();
		}else{
			$this-> retrieveAllNotes();
		}
	}
}

// MARK :- NOTE METHODS
$notes = new Notes($servername, $username, $password, $dbname);
$notes-> enableDebug();
$notes-> service();
?>