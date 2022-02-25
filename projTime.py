from graphics import *

def timehours(prg):
	hour = [0.0,0.0,0.0]
	hour[0] = float(prg/3600.0)
	hour[1] = ((hour[0] - float(int(hour[0]))) * 3600.0) / 60.0
	hour[2] = (hour[1] - float(int(hour[1]))) * 60
	return hour
	
def projTimes(timeformat, perc, totalDistance):
	perc = float(perc)/float(totalDistance)
	times = timeformat.split(":")
	time = [0,0,0]
	for i in range(len(times)):
		time[i] = float(times[i])
	
	prg = float(time[0]*3600+time[1]*60+time[2]) / 	float(perc)
	projTime = timehours(prg)
	hours = int(projTime[0])
	minutes = int(projTime[1])
	seconds = int(projTime[2])
	
	timeStamp = "Projected Time: " + str(hours) + " hours " + str(minutes) + " minutes " + str(seconds) + " seconds"
	return timeStamp

version = "v1.0"
print("Projected Time version: {0}".format(version))

win = GraphWin("Projected Time {0}".format(version), width = 500, height = 500) # create a window
win.setCoords(-100, -100, 100, 100) # set the coordinates of the window; bottom left is (-100, -100) and top right is (100, 100)

image = Image(Point(0,5),"TestPic2.gif")
image.draw(win)

box1 = Entry(Point(25,0),20) # time
box1.draw(win)

box2 = Entry(Point(25,20),20) # distance ran
box2.draw(win)

box3 = Entry(Point(25,10),20) # total distance
box3.draw(win)

txt = Text(Point(0,78),"")
txt.setText(box1.getText())
txt.draw(win)

txt1 = Text(Point(-19,0),"")
txt1.setText("Time: ")
txt1.draw(win)

txt2 = Text(Point(-31,20),"")
txt2.setText("Distance Ran: ")
txt2.draw(win)

txt3 = Text(Point(-32,10),"")
txt3.setText("Total Distance: ")
txt3.draw(win)

while box1.getText()!="Error":
	try:
		txt.setText(projTimes(box1.getText(), box2.getText(), box3.getText()))
	except ValueError as err:
		txt.setText("Working on Projected Time")
	
	
print(win.getMouse()) # pause before closing

