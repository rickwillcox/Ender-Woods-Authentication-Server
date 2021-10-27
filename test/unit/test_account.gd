extends "res://addons/gut/test.gd"

var characters = 'abcdefghijklmnopqrstuvwxyz'
var numbers = '0123456789'
var test_username 
var test_password 
var test_salt 
var test_auth_token 
var test_session_token = "0000000000"
var res
var db

func before_all():
	randomize()
	test_username = generate_word(characters, 25) 
	test_password = generate_word(characters, 25).sha256_text()
	test_salt = generate_word(characters, 25).sha256_text()
	test_auth_token = generate_word(characters, 25).sha256_text()
	print("Auth Token test: ", test_auth_token)
	db = DatabaseConnection.db
	PlayerData.dbRefreshPlayerIDs()

func test_Account():
	subtest_CreateAccount()
	subtest_AddAuthToken()
	subtest_AddSessionToken()
	subtest_AddItemSlots()
	subtest_DeleteAccount()
	
func subtest_CreateAccount():
	res = PlayerData.dbCreateAccount(test_username, test_password, test_salt, true)
	assert_eq(0, res, "Create Account")
	
func subtest_AddAuthToken():
	res = PlayerData.dbAddAuthToken(test_username, test_auth_token)
	assert_eq(0, res, "Add Auth Token")

func subtest_AddSessionToken():
	res = PlayerData.dbAddSessionToken(test_session_token, test_auth_token)
	assert_eq(0, res, "Add Session Token")

func subtest_AddItemSlots():
	res = PlayerData.dbAddItemSlots(test_username)
	assert_eq(0, res, "Add Item Slots")
	
func subtest_DeleteAccount():
	res = PlayerData.dbDeleteAccount(test_username, test_password, test_salt)
	assert_eq(0, res, "Delete Account")
	
func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word

