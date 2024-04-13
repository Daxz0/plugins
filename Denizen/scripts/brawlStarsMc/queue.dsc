


queueMenu:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <script.parsed_key[data.title].unseparated>
    data:
        title:
        - <&f><static[<proc[negative_spacing].context[8].font[spaces]>]>
        - <&chr[E001].font[guis]>
        - <static[<proc[negative_spacing].context[165].font[spaces]><&chr[AA01].font[gamemodes]>]>
        - <proc[negative_spacing].context[45].font[spaces]><element[Duels].font[bs_font]>
        - <proc[negative_spacing].context[22].font[spaces]><element[Warriors Way].font[bs_font_sub]>
    definitions:
        p: pane_black
    size: 54
    slots:
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []

duels_icon:
    type: item
    material: lime_stained_glass_pane
    mechanisms:
        custom_model_data: 501