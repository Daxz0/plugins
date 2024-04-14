speedCalc:
    type: procedure
    debug: false
    definitions: speed
    script:
        - define output <[speed].div[300].div[100]>
        - determine <[output].add[0.1]>