A Noita Community Mod Collaboration! Following the Noita Fair Mod, this mod intends to make the game more difficult/challenging.

(Note that this does NOT mean adding memey bullshit or otherwise making the game more frustrating, this isn't Fairmod! The difficulty should ideally be fun and engaging.)


<ins>Development has officially begun as of October 1st</ins> and the mod will be released midnight after Halloween, or Novermber 1st 00:00 (you can still further develop/work on the mod post-release).

# Implemented Features
- `nerfed_combat_healing`
  - On taking damage, you gain a healblock status effect
  - For every 1% of max health you take as damage, you gain 2 seconds of wounded up to a maximum of 10 seconds from a single instance of damage
  - As you continually take more damage, the wounded timer you have can grow up to a maximum of 60 seconds, at which point it cannot be risen any higher
- `phantom_nemesis`
  - A phantom is haunting you and will possess nearby enemies, granting them powerful abilities in order to drag you into the grave with them.
  - The Phantom is named Ira and will grow stronger with each biome you visit, they will take the situation & previous encounters into consideration when selecting abilities to grant their next host in order to best slay you.
  - You have a 3 minute grace period before Ira begins haunting you, after which Ira will continually possess a new target every minute to hunt you down; however Ira will stop haunting you briefly if you banish them by killing their host, this grace period timer after each kill also grows longer with each biome you visit.
  - Ira can be banished instantly by charming their host with pheromones but this will anger Ira greatly and you may have a harder time fending them off in future encounters.
- `splash_text`
  - Pause menu will have a random splash message on it
- `cheeseless_triggers`
  - Trigger spells pay their payload's cast delay
  - `Add Trigger`, `Add Timer` and `Add Death Trigger` don't give free modifiers anymore and properly applies spell's cast delay
- `no_more_chainsaw_wrapping`
  - Within the cast state, chainsaw and luminous drill only give cast delay to eachother, the full state is reset to what it was *before* either of the spells was cast, once another spell is cast. This means any spell completely breaks the momentum of chainsaw.
- `trappier_traps`
  - Made a bunch of the box traps unkickable.
  - Wall traps shotgun projectiles.
- `worse_hearts`
  - Holy mountain hearts no longer grant health increase
- `vanilla_perk_rebalances`
  - All-Seeing Eye now grants vision around the cursor only, rather than lighting up the entire screen.
  - Most Immunity perks have been reworked into Protection perks, halving damage taken by the corresponding damage type. These perks now stack up to 3 times, for a total damage reduction of up to 87.5%.
  - Exploding Corpses and Oil Blood now also grant explosion/fire protection, rather than immunity.
  - Stainless Armour and Permanent Shield can now be stacked a maximum of 3 times each.
- `truly_limited_spells`
  - The Unlimited Spells perk has been removed.
  - A new perk gives enemies a chance to drop "spell gems", which restore a few spell charges on pickup.
  - The Wand Refresh spell has been removed. (Alt Fire Anything substitutes the copy dropped by MoM)
  - Greek spells are now (by default) limited to 30 uses.
  - Two new late-game spells allow you to cast limited spells with 0 remaining charges.
