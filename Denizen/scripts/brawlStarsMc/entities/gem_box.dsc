gem_box:
    type: entity
    entity_type: slime
    mechanisms:
        size: 3
        max_health: 5000
        health: 5000
        has_ai: false
    flags:
        customMob: true

tetwetwe:
    type: world
    debug: false
    events:
        on slime splits:
            - determine passively cancelled