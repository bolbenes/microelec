############################################################
## EZwave - Saved Window File
## Monday, April 29, 2013 at 12:17:46 PM CEST
##
## Note: This is an auto-generated file.
##
## In case of modification, Do not remove this comment
############################################################

onerror {resume}

# ===== Open required Database =====
dataset open /stud/users/promo14/hilaire/CBN/conso_dyn/worksim/tmp.wdb tmp

# ===== Open the window =====
wave addwindow -x 0  -y 0 -width 1419  -height 795 -divider 0.92

# ===== Create row #1 =====
add wave  -show TRAN.v -color -16711936 -separator : -terminals  :conso_dyn_tb:bd0:din_real1


# ===== Create row #2 =====
add wave  -show TRAN.v -color -256 -separator : -terminals  :conso_dyn_tb:bd0:din_real2


# ===== Create row #3 =====
add wave  -show TRAN.v -color -16744193 -separator : -signals  :conso_dyn_tb:bd0:energy


# ===== Create row #4 =====
add wave  -show TRAN.var -color -32768 -separator : -signals  :conso_dyn_tb:bd0:intern_energy


# ===== Create row #5 =====
add wave  -show TRAN.v -color -65281 -separator : -signals  :conso_dyn_tb:bd0:tt_val


# ===== Create row #6 =====
add wave  -show TRAN.v -color -16711681 -separator : -signals  :conso_dyn_tb:bd0:capa_charge_val


# ====== Create the cursors, markers and measurements =====
