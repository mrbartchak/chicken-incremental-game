extends Node

const MAJOR = 0
const MINOR = 2
const PATCH = 1

const VERSION_STRING = "0.2.1"

func get_version() -> String:
	return VERSION_STRING

func get_full_version() -> String:
	return "v" + VERSION_STRING
