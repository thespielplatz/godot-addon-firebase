extends Node
class_name FirebaseUser

var local_id := ""            # uid of the current user.
var email := ""
var email_verified := false  
var password_updated_at := 0
var last_refresh_at := 0      
var last_login_at := 0        
var created_at := 0           

func _init(userdata : Dictionary):
	local_id = userdata.localId
	email = userdata.get("email", "")
	email_verified = userdata.get("emailVerified", false)
	password_updated_at = int(userdata.get("passwordUpdatedAt", "0"))
	last_refresh_at = int(userdata.lastRefreshAt)
	last_login_at = int(userdata.lastLoginAt)
	created_at = int(userdata.createdAt)

func _to_string()->String:
	var string = ""
	string += "--- Firebase User ---\n"
	string += "LocalId:                 " + local_id + "ﬁ\n"
	string += "Email:                   " + email + "ﬁ\n"
	string += "Email Verivied:          " + str(email_verified) + "ﬁ\n"
	string += "Password Updated At:     " + str(password_updated_at) + "ﬁ\n"
	string += "Last Refresh At:         " + str(last_refresh_at) + "ﬁ\n"
	string += "Last Login Updated At:   " + str(last_login_at) + "ﬁ\n"
	string += "Created At:              " + str(created_at) + "ﬁ\n"
	return string
