export PATH=/usr/local/Library/Canopy/User/bin:$PATH:/usr/texbin:/opt/local/bin

function jabref() {
  nohup java -jar /Applications/JabRef.app/Contents/Resources/Java/JabRef-2.10.jar 1>/dev/null 2>&1 &
}

# usage: ro /path/to/eps/file/at/crossroads/figure.eps
function ro() {
  scp cross:${1%.eps}.{eps,dat,gp} /tmp
  open /tmp/$(basename $1) &
}

export CVS_RSH=ssh
