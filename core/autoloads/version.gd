extends Node

const MAJOR = 0
const MINOR = 1
const PATCH = 0

const VERSION_STRING = "0.1.0"

func get_version() -> String:
	return VERSION_STRING

func get_full_version() -> String:
	return "v" + VERSION_STRING
