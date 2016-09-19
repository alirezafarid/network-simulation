extensions [CSV profiler]

;; Load External Files
__includes [
  "helper-functions.nls"
  "test-code.nls"
  "global-profiles.nls"

  ;"Negative-Payoff/Lab2-Random-Vs-Popular-with-isolated-tastes.nls"
  ;"Negative-Payoff/profiles/stock-document-popularity-profile.nls"
  ;"Negative-Payoff/profiles/stock-viral-profile.nls"



;  Experiments

  "Negative-Payoff/plot.nls"
  "Negative-Payoff/experiments.nls"
  "Negative-Payoff/profiles/peer-popularity-profile.nls"
  "Negative-Payoff/profiles/peer-popularity-producer-profile.nls"

  "Negative-Payoff/profiles/peer-follow-profile.nls"
  "Negative-Payoff/profiles/peer-follow-producer-profile.nls"

  "Negative-Payoff/profiles/peer-similarity-profile.nls"
  "Negative-Payoff/profiles/peer-similarity-producer-profile.nls"

  "Negative-Payoff/profiles/complete-random-profile.nls"
  "Negative-Payoff/profiles/complete-random-producer-profile.nls"

  "Negative-Payoff/profiles/document-popularity-profile.nls"
  "Negative-Payoff/profiles/document-popularity-producer-profile.nls"

;  End of Experiments

  "Negative-Payoff/strategies/candidates.nls"
  "Negative-Payoff/strategies/follow.nls"
  "Negative-Payoff/strategies/leave.nls"
  "Negative-Payoff/strategies/like.nls"
  "Negative-Payoff/strategies/payoff.nls"
  "Negative-Payoff/strategies/publish.nls"
  "Negative-Payoff/strategies/rank.nls"

]

globals[
  user
  inactive-color
  number-of-agents
  number-of-iterations
  total-number-of-turns
  iterationCounter
]

;; Assign each turtle a property
turtles-own[
  document?                 ;;Is this agent a document or a peer?
  active?                   ;;Is this agent currently active?
  tags                      ;;The taste(s) of this agent
  score                     ;;The score of this agent
  turns                     ;;The number of times this agent has acted
  max-k                     ;;The size of the top-k
  max-m                     ;;The size of the top-m (aka candidates list for who to follow)
  last-turn                 ;;The last turn this peer was the user
  children                  ;;Get the children of this file

  num-likes
  iteration-num             ;;Keeps track of current iteration number in experiment.
  iteration-turn-list       ;;List for checking whether this agent has acted in each iteration.


  turn-payoff-list          ;;List of all turn scores
  default-color             ;;default color when a peer is active

  turn-ranked
  turn-payoff
  turn-liked
  turn-candidates
  turn-followed
  turn-published
  turn-leave?
]

;; SETUP PROCEDURE: initialize variables and classes
to simulator-setup
  ;;Clear the values from the last simulation
  clear-all

  ;file-open "/Users/alirezafaridamin/Desktop/plot.csv"
  file-open "/Users/alirezafaridamin/Desktop/histogramV.csv"
  file-print "XXX"
  set iterationCounter 0
  set number-of-agents  30
  set number-of-iterations 80
  set total-number-of-turns 0

  reset-ticks

  ;;Set the random seed if a value for it was provided
  ifelse (random-seed?) [random-seed the-random-seed] [random-seed new-seed]
  set user nobody
  set inactive-color black
  set-default-shape turtles "circle"
  ask links [set thickness 1]
end


;; TEMP: relieves error in setup
to turtles-layout
  set size 1
  set label who
  set label-color black
end

;; GO PROCEDURE: This procedure is called once each 'tick', it is the top-level function for the running simulation
to go

  ;;Select a random peer, and ask it to run its own "go" procedure
  ask (one-of turtles with [not document?]) [

   ;if [active?] of self [
      set user self


      highlight-peer

        if iteration-num + 1  < number-of-iterations
       [
          ifelse    total-number-of-turns < iteration-num + 1 * number-of-agents [

               if item iteration-num iteration-turn-list = false [

                   act
                   update-variables
                   set iteration-turn-list replace-item iteration-num iteration-turn-list true
                   set total-number-of-turns total-number-of-turns + 1

               ]
      ]
      [
         set iteration-num iteration-num + 1

         if  item iteration-num iteration-turn-list = false [

            act
            update-variables
            set iteration-turn-list replace-item iteration-num iteration-turn-list true
            set total-number-of-turns total-number-of-turns + 1

        ]
      ]
  ]
;]

;     run (word "set turn-leave? " [breed] of self "-leave?")
;    update-variables
  ]

if( number-of-iterations * number-of-agents >= total-number-of-turns )
[tick

  ;drawDiagram
  drawHistogram
 if ( number-of-iterations * number-of-agents = total-number-of-turns )
 [
    set total-number-of-turns total-number-of-turns + 1
    file-close
 ]

]






end

to act

 run (word "set turn-ranked " [breed] of self "-rank")

  run (word "set turn-payoff " [breed] of self "-payoff")

  run (word "set turn-liked " [breed] of self "-like")

  run (word "set turn-followed " [breed] of self "-follow")

  run (word "set turn-published " [breed] of self "-publish")

end

to update-variables
  set turns turns + 1
  set num-likes num-likes + 1
  set score score + turn-payoff
  set turn-payoff-list lput turn-payoff turn-payoff-list
  set last-turn ticks
  set children (sentence turn-published children)
end

to my-layout
  ask patches [ifelse (pxcor = 0) [ set pcolor white - 2 ] [ set pcolor white - .3 ]]

  ask turtles [
    ifelse (document?) [set xcor 12][set xcor -12]
  ]
  let factor sqrt count turtles
  repeat 100 [layout-spring turtles links (1 / factor) (7 / factor) (1 / factor)]
  display
end

to highlight-peer
  ask other turtles [set size 1]      ;;reset the original sizes and colors
  set size 2.5
end
@#$#@#$#@
GRAPHICS-WINDOW
227
10
696
500
25
25
9.0
1
10
1
1
1
0
0
0
1
-25
25
-25
25
1
1
1
ticks
12.0

SWITCH
32
135
214
168
random-seed?
random-seed?
1
1
-1000

INPUTBOX
58
65
212
125
the-random-seed
100
1
0
Number

BUTTON
5
10
79
43
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
83
10
154
43
Step
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
157
11
225
44
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
731
68
1314
305
payoff
Iteration number
Average payoff
0.0
15.0
0.0
15.0
true
true
"" ""
PENS
"consumer tag1" 1.0 0 -2674135 true "" "carefully[\nif (ticks > 0 and total-number-of-turns mod  number-of-agents = 0) [\nplot mean [score] of turtles with [not document? and  breed = document-popularity-profiles and tags = [1]] ]\n\n]\n[\nplot 0\n]"
"consumer tag0" 1.0 0 -14070903 true "" "carefully[\nif (ticks > 0 and total-number-of-turns mod  number-of-agents = 0) [\nplot mean [score] of turtles with [not document? and  breed = document-popularity-profiles and tags = [0]] ]\n\n]\n[\nplot 0\n]"

PLOT
717
330
1156
482
Score Distrib
Nodes
# Peers
0.0
100.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "histogram [score] of turtles with [not document? and active?]"

BUTTON
66
240
193
273
Hide Connections
ask connect-links [set hidden? true]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
65
291
176
324
Hide Memories
ask memory-links [set hidden? true]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
731
33
1150
75
ask turtle 0 [ask my-out-connect-links [set hidden? false]]
11
0.0
1

BUTTON
65
343
154
376
Hide ranks
ask rank-links [set hidden? true]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
756
544
912
589
NIL
total-number-of-turns
17
1
11

BUTTON
61
450
199
483
performance test
setup                  ;; set up the model\nprofiler:start         ;; start profiling\nrepeat 10 [ go ]       ;; run something you want to measure\nprofiler:stop          ;; stop profiling\nprint profiler:report  ;; view the results\nprofiler:reset         ;; clear the data
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Start-Network-5" repetitions="1000" runMetricsEveryStep="true">
    <setup>General-Network-1
;repeat 10 [go]
ask profiles1 [set active? false]
create-profiles6 1 [profiles-setup 5 2 1 [0 1] cyan]</setup>
    <go>go</go>
    <timeLimit steps="10"/>
    <metric>sum [score] of profiles6</metric>
    <enumeratedValueSet variable="the-random-seed">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Evening-Network-5" repetitions="1000" runMetricsEveryStep="true">
    <setup>General-Network-1
repeat 160 [go]
ask profiles1 [set active? false]
create-profiles6 1 [profiles-setup 5 2 1 [0 1] cyan]</setup>
    <go>go</go>
    <timeLimit steps="10"/>
    <metric>sum [score] of profiles6</metric>
    <enumeratedValueSet variable="the-random-seed">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Complete-Network-4" repetitions="1000" runMetricsEveryStep="true">
    <setup>General-Network-1
repeat 1000 [go]
ask profiles1 [set active? false]
create-profiles5 1 [profiles-setup 5 2 1 [0 1] cyan]</setup>
    <go>go</go>
    <timeLimit steps="10"/>
    <metric>sum [score] of profiles5</metric>
    <enumeratedValueSet variable="the-random-seed">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="1000" runMetricsEveryStep="true">
    <setup>setup
go</setup>
    <go>go</go>
    <timeLimit steps="40"/>
    <metric>[breed] of user</metric>
    <metric>[turns] of user</metric>
    <metric>[turn-payoff] of user</metric>
    <metric>[score] of user</metric>
    <enumeratedValueSet variable="the-random-seed">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-larger-network" repetitions="1000" runMetricsEveryStep="true">
    <setup>setup
go</setup>
    <go>go</go>
    <timeLimit steps="40"/>
    <metric>[breed] of user</metric>
    <metric>[turns] of user</metric>
    <metric>[turn-payoff] of user</metric>
    <metric>[score] of user</metric>
    <enumeratedValueSet variable="the-random-seed">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="smaller-netowork-1" repetitions="100" runMetricsEveryStep="true">
    <setup>setup
go</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>[breed] of user</metric>
    <metric>[turns] of user</metric>
    <metric>[turn-payoff] of user</metric>
    <metric>[score] of user</metric>
    <metric>length [children] of user</metric>
    <enumeratedValueSet variable="the-random-seed">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experimentTest" repetitions="2" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="4000"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="random-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="the-random-seed">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
