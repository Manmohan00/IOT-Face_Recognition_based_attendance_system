import cv2
import numpy as np
import face_recognition
import os
import time
from datetime import datetime
import pyrebase
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import storage

config = {
  "apiKey": "AIzaSyA6eC_dzZdIckLJzD70mpBOzMzKlpPm37A",
  "authDomain": "face-attendance-a2b16.firebaseapp.com",
  "projectId": "face-attendance-a2b16",
  "storageBucket": "face-attendance-a2b16.appspot.com",
  "messagingSenderId": "854591258590",
  "appId": "1:854591258590:web:74516097f572ffbc82674f",
  "measurementId": "G-77SRZMGRL9",
  "databaseURL" : "https://face-attendance-a2b16-default-rtdb.firebaseio.com/"
}

cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()
##pyrebase below##
firebase = pyrebase.initialize_app(config)
storage = firebase.storage()

path = 'imagefromfb'
images = []
classNames = []
myList = os.listdir(path)
print(myList)


def downloadimages():                     ####this is not called yet
  docs = db.collection('Customer').stream()
  for doc in docs:
    doc = doc.to_dict()
    print(doc.get('Name'))
    storage.child(f"Customer/{doc.get('Name')}.jpg").download(f"imagefromfb/{doc.get('Name')}.jpg")
  docs = db.collection('Employee').stream()
  for doc in docs:
    doc = doc.to_dict()
    print(doc.get('Name'))
    storage.child(f"Employee/{doc.get('Name')}.jpg").download(f"imagefromfb/{doc.get('Name')}.jpg")


for cls in myList:
    currentImg = cv2.imread(f'{path}/{cls}')
    images.append(currentImg)
    classNames.append(os.path.splitext(cls)[0])


def findencodings(images):
    encodeList = []
    for img in images:
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        encode = face_recognition.face_encodings(img)[0]
        encodeList.append(encode)
    return encodeList

encodeListKnow = findencodings(images)
print('Encoding Complete')

def markAttendanceLocally(name,post): # condition to deleted the  csv data everyday
    with open('attendance.csv', 'r+') as f:
        myDataList = f.readlines()
        nameList = []
        for line in myDataList:
            print(f'#####    {line}')
            entry = line.split(',')
            nameList.append(entry[0])
        if name not in nameList:
            Attendancetime = time.strftime('%I:%M %p', time.localtime())
            Attendanceday = time.strftime('%d/%b/%Y', time.localtime())
            AttendanceMonth = time.strftime('%B', time.localtime())
            f.writelines(f'\n{name},{Attendancetime},{Attendanceday}')
            markAttendanceonCloud(Attendancetime, Attendanceday,AttendanceMonth, name, post)
            return "Attendance Added"
        else:
            return "Already Added"

def saveUnknown(img):
    Attendancetime = time.strftime('%I-%M %p', time.localtime())
    Attendanceday = time.strftime('%d-%b-%Y', time.localtime())
    unknownname = f"{Attendanceday},{Attendancetime}.jpg "
    cv2.imwrite(f'unknown/{unknownname}', img)
    storage.child(f'Unknown/{unknownname}').put(f'unknown/{unknownname}', None)
    return False

def markAttendanceonCloud(Attendancetime, Attendanceday,AttendanceMonth, name, post):
    db.collection(post).document(name).collection('Attendance').add({
        "Date" : f"{Attendanceday},{Attendancetime}",
        "Month" : f"{AttendanceMonth}"
        #Add state present or absent?
    }, )

def splittext(name):
    temp = name.split("_")
    name = temp[0]
    post = temp[1]
    return name,post


cap = cv2.VideoCapture(0)

while True:
    success, img = cap.read()
    imgSmall = cv2.resize(img,(0,0),None,0.25,0.25)
    imgSmall = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    facesCurrent = face_recognition.face_locations(imgSmall)
    encodeCurrent = face_recognition.face_encodings(imgSmall, facesCurrent)

    for encodeFace, faceLoc in zip(encodeCurrent, facesCurrent):
        matches = face_recognition.compare_faces(encodeListKnow, encodeFace)
        faceDistance = face_recognition.face_distance(encodeListKnow, encodeFace)
        matchIndex = np.argmin(faceDistance)

        if matches[matchIndex]:
            name = classNames[matchIndex]
            name, post = splittext(name)
            print(name,post)
            y1,x2,y2,x1 = faceLoc
            cv2.rectangle(img,(x1,y1),(x2,y2),(0,255,0),2)
            cv2.rectangle(img,(x1,y2-35),(x2,y2),(225,0,0),cv2.FILLED)
            cv2.putText(img,name,(x1+20,y2-6),cv2.FONT_HERSHEY_SIMPLEX,0.5,(255,255,255),2)
            Status = markAttendanceLocally(name,post)
            cv2.putText(img, Status, (x1 - 20, y2 + 30), cv2.FONT_HERSHEY_COMPLEX, 0.8, (0, 255, 0), 2)
        # else:
        #     captured = True
        #     while(captured):
        #         cv2.putText(img, 'Unknown', (70, 100), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 2)
        #         cv2.putText(img, 'Capturing Image...', (70, 120), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 2)
        #         captured = saveUnknown(img)
        #     cap.release()
        #     cv2.destroyAllWindows()
####Add Condition to clear / or deleted CSV file daily
    cv2.imshow('Camera', img)
    cv2.waitKey(1)

