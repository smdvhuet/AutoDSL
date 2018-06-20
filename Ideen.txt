Benötigte Werte
- Generelle Buttons
- Geschwindigkeit
- Throttle / Brake 
- Sensorwerte
- Lidar nach hinten?
- Relative Geschwindigkeit des Vorfahrenden (Was ist mit Hinterfahrenden?)
TODO: Ergänzen

Aufbau:

when <event> (is active | ends | starts):
    (error message : <String>)?
    (maximum reaction time : <int>)?{
    (inv: <BoolExpr>)+
} 

event <Name> {
    start condition: <BoolExpr>
    end condition: <BoolExpr>
}

