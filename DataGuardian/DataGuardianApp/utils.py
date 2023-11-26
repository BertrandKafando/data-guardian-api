from django.core.mail import EmailMessage
from django.db import connection
import base64
import threading


class EmailThread(threading.Thread):

    def __init__(self, email):
        self.email = email
        threading.Thread.__init__(self)

    def run(self):
        self.email.send()


class Email:

    @staticmethod
    def send_email(data):
        email = EmailMessage(
            subject=data['email_subject'], body=data['email_body'], to=[data['to_email']])
        EmailThread(email).start()


class Base64 :
    def isBase64(sb):
            try:
                if isinstance(sb, str):
                    # If there's any unicode here, an exception will be thrown and the function will return false
                    sb_bytes = bytes(sb, 'ascii')
                elif isinstance(sb, bytes):
                    sb_bytes = sb
                else:
                    raise ValueError("Argument must be string or bytes")
                return base64.b64encode(base64.b64decode(sb_bytes)) == sb_bytes
            except Exception:
                return False
            

class DBFunctions:


    def executer_fonction_postgresql(nom_fonction, *args):

        with connection.cursor() as cursor:

            try:

                params = ', '.join('%s' for _ in args)
                
                cursor.execute(f"SELECT {nom_fonction}({params});", args)
                
                result = cursor.fetchone()
                
                return result
            
            except Exception as e:

                print(f"Erreur lors de l'exécution de la fonction {nom_fonction}: {e}")
                return -1
