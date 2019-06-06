import hashlib

def get_token(login, passwd):
    result_string = login + passwd
    token = hashlib.sha256(result_string.encode()).hexdigest()
    return str(token)
