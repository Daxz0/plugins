speedCalc:
    type: procedure
    debug: false
    definitions: speed
    script:
        - define 1 <[speed].div[300]>
        - define 2 <element[0.1].div[<[speed]>]>
        - define output <[2].add[0.1]>
        - determine <[output]>