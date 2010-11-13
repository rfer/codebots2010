import termios, sys, os
import serial
import time

TERMIOS = termios

KEYS = ['a','A','w','W','s','S','d','D']

SERIALPORT = '/dev/ttyUSB1'
SERIALBR = 9600 

MSG_PREFIX = 'cbots2k10-'


def getkey():
        fd = sys.stdin.fileno()
        old = termios.tcgetattr(fd)
        new = termios.tcgetattr(fd)
        new[3] = new[3] & ~TERMIOS.ICANON & ~TERMIOS.ECHO
        new[6][TERMIOS.VMIN] = 1
        new[6][TERMIOS.VTIME] = 0
        termios.tcsetattr(fd, TERMIOS.TCSANOW, new)
        c = None
        try:
                c = os.read(fd, 1)
        finally:
                termios.tcsetattr(fd, TERMIOS.TCSAFLUSH, old)
        return c

#def initSerial():
#	try:
#		arduino = serial.Serial(SERIALPORT, SERIALBR)
#		print "Successfuly connected to",SERIALPORT,"at",SERIALBR
#	except Exception:
#		print "Failed to aquire serial connetion to",SERIALPORT,". Moving on..."

if __name__ == '__main__':
        print 'Codebits 2010 Robot Control Console'

	#initSerial()
	#arduino = serial.Serial(SERIALPORT, SERIALBR)
	arduino = serial.Serial('/dev/ttyUSB1', 9600)
        while True:
                c = getkey()

		if c in KEYS:
                	print "captured key", c
			arduino.write(c)
			time.sleep(0.255)
		elif c == 'q':
			break

	print "Laters."


