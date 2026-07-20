-- Auto-generated from fishing_bait_affinity.sql + fishing_group.sql.
-- For each area, lists fish and the bait(s) that only that fish (of the
-- fish sharing that area) will bite -- i.e. a bait that isolates it from
-- everything else biting nearby. Within each fish, reusable lures are
-- listed before consumable baits, then by power descending.
-- Regenerate rather than hand-edit.
local IsolatingBaits = {}

IsolatingBaits["Aht Urhgan Whitegate, Whole Zone"] = {
    { fish = "Denizanasi", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Crayfish Paste", power = 2, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Hamsi", isolatable = false },
    { fish = "Kalamar", isolatable = false },
}
IsolatingBaits["Al Zahbi, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false } } },
    { fish = "Kayabaligi", isolatable = true, baits = { { bait = "Minnow", power = 2, lure = true } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Sazanbaligi", isolatable = true, baits = { { bait = "Shrimp Lure", power = 2, lure = true } } },
    { fish = "Tiny Goldfish", isolatable = false },
    { fish = "Yilanbaligi", isolatable = true, baits = { { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false } } },
}
IsolatingBaits["Arrapago Reef, Whole Zone"] = {
    { fish = "Ahtapot", isolatable = false },
    { fish = "Istakoz", isolatable = false },
    { fish = "Istiridye", isolatable = false },
    { fish = "Mercanbaligi", isolatable = false },
    { fish = "Rhinochimera", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true } } },
}
IsolatingBaits["Aydeewa Subterrane, Whole Zone"] = {
    { fish = "Blindfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Ball of Insect Paste", power = 3, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
    { fish = "Cave Cherax", isolatable = true, baits = { { bait = "Minnow", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Piece of Rotten Meat", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false } } },
    { fish = "Lamp Marimo", isolatable = true, baits = { { bait = "Fly Lure", power = 2, lure = true }, { bait = "Sabiki Rig", power = 2, lure = true }, { bait = "Lugworm", power = 2, lure = false } } },
}
IsolatingBaits["Bastok Markets, North Side"] = {
    { fish = "Black Eel", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Crayfish Paste", power = 3, lure = false }, { bait = "Shell Bug", power = 3, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Gold Carp", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Tricolored Carp", isolatable = false },
}
IsolatingBaits["Bastok Markets, South Side"] = {
    { fish = "Black Eel", isolatable = true, baits = { { bait = "Ball of Crayfish Paste", power = 3, lure = false } } },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
}
IsolatingBaits["Bastok Mines, Whole Zone"] = {
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Batallia Downs, North Seaside"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Black Sole", isolatable = false },
    { fish = "Bluetail", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false } } },
    { fish = "Cone Calamary", isolatable = false },
    { fish = "Nosteau Herring", isolatable = false },
    { fish = "Silver Shark", isolatable = false },
    { fish = "Tiger Cod", isolatable = false },
    { fish = "Yellow Globe", isolatable = false },
}
IsolatingBaits["Batallia Downs, South Seaside"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Black Sole", isolatable = false },
    { fish = "Bluetail", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false } } },
    { fish = "Cone Calamary", isolatable = false },
    { fish = "Nosteau Herring", isolatable = false },
    { fish = "Silver Shark", isolatable = false },
    { fish = "Tiger Cod", isolatable = false },
    { fish = "Yellow Globe", isolatable = false },
}
IsolatingBaits["Beaucedine Glacier, Ponds"] = {
    { fish = "Emperor Fish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Ball of Sardine Paste", power = 3, lure = false }, { bait = "Ball of Trout Paste", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 3, lure = false }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false } } },
    { fish = "Icefish", isolatable = true, baits = { { bait = "Sabiki Rig", power = 3, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Little Worm", power = 2, lure = false } } },
}
IsolatingBaits["Beaucedine Glacier, Seaside"] = {
    { fish = "Black Sole", isolatable = true, baits = { { bait = "Sinking Minnow", power = 3, lure = true }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Bluetail", isolatable = true, baits = { { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Cone Calamary", isolatable = false },
    { fish = "Gigant Squid", isolatable = false },
    { fish = "Nosteau Herring", isolatable = true, baits = { { bait = "Ball of Sardine Paste", power = 2, lure = false } } },
    { fish = "Tiger Cod", isolatable = false },
    { fish = "Yellow Globe", isolatable = true, baits = { { bait = "Worm Lure", power = 3, lure = true } } },
}
IsolatingBaits["Bhaflau Thickets, Whole Zone"] = {
    { fish = "Alabaligi", isolatable = true, baits = { { bait = "Fly Lure", power = 2, lure = true } } },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false } } },
    { fish = "Kayabaligi", isolatable = false },
    { fish = "Morinabaligi", isolatable = false },
    { fish = "Sazanbaligi", isolatable = false },
    { fish = "Turnabaligi", isolatable = false },
    { fish = "Yilanbaligi", isolatable = false },
}
IsolatingBaits["Bibiki Bay, BB - Other Seaside"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false } } },
    { fish = "Cone Calamary", isolatable = false },
    { fish = "Zafmlug Bass", isolatable = false },
}
IsolatingBaits["Bibiki Bay, BB - South Seaside"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Bladefish", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false } } },
    { fish = "Cone Calamary", isolatable = false },
    { fish = "Zafmlug Bass", isolatable = false },
}
IsolatingBaits["Bibiki Bay, PI - East Beach"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Bluetail", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false } } },
    { fish = "Moorish Idol", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Shall Shell", isolatable = false },
    { fish = "Vongola Clam", isolatable = false },
}
IsolatingBaits["Bibiki Bay, PI - North Beach"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Bluetail", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false } } },
    { fish = "Moorish Idol", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Shall Shell", isolatable = false },
    { fish = "Trilobite", isolatable = false },
    { fish = "Vongola Clam", isolatable = false },
}
IsolatingBaits["Bibiki Bay, PI - South Beach"] = {
    { fish = "Bibikibo", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Minnow", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Moorish Idol", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Shall Shell", isolatable = false },
    { fish = "Trilobite", isolatable = false },
    { fish = "Vongola Clam", isolatable = false },
}
IsolatingBaits["Bibiki Bay, PI - West Beach"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Bluetail", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false } } },
    { fish = "Moorish Idol", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Shall Shell", isolatable = false },
    { fish = "Vongola Clam", isolatable = false },
}
IsolatingBaits["Bostaunieux Oubliette, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Buburimu Peninsula, Whole Zone"] = {
    { fish = "Bluetail", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Shall Shell", isolatable = false },
    { fish = "Yellow Globe", isolatable = true, baits = { { bait = "Sabiki Rig", power = 3, lure = true }, { bait = "Worm Lure", power = 3, lure = true }, { bait = "Lugworm", power = 2, lure = false } } },
}
IsolatingBaits["Caedarva Mire, Whole Zone"] = {
    { fish = "Black Ghost", isolatable = false },
    { fish = "Caedarva Frog", isolatable = false },
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 3, lure = false }, { bait = "Ball of Trout Paste", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Kaplumbaga", isolatable = false },
    { fish = "Yayinbaligi", isolatable = false },
}
IsolatingBaits["Cape Teriggan, Whole Zone"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false } } },
    { fish = "Greedie", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Shall Shell", isolatable = false },
    { fish = "Zafmlug Bass", isolatable = false },
}
IsolatingBaits["Carpenters' Landing, Central Landing"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Little Worm", power = 2, lure = false } } },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 3, lure = false }, { bait = "Ball of Trout Paste", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Muddy Siredon", isolatable = true, baits = { { bait = "Fly Lure", power = 2, lure = true }, { bait = "Lufaise Fly", power = 2, lure = false } } },
}
IsolatingBaits["Carpenters' Landing, North Landing"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Muddy Siredon", isolatable = false },
    { fish = "Shining Trout", isolatable = false },
}
IsolatingBaits["Carpenters' Landing, Other Waterside Center"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Muddy Siredon", isolatable = false },
    { fish = "Phanauet Newt", isolatable = false },
}
IsolatingBaits["Carpenters' Landing, Other Waterside North"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Muddy Siredon", isolatable = false },
    { fish = "Phanauet Newt", isolatable = false },
}
IsolatingBaits["Carpenters' Landing, Other Waterside South"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Muddy Siredon", isolatable = false },
    { fish = "Phanauet Newt", isolatable = false },
}
IsolatingBaits["Carpenters' Landing, South Landing"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Muddy Siredon", isolatable = false },
    { fish = "Shining Trout", isolatable = false },
}
IsolatingBaits["Castle Oztroja, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Dangruf Wadi, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Davoi, Basin of a Waterfall"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false } } },
    { fish = "Gold Carp", isolatable = false },
    { fish = "Red Terrapin", isolatable = true, baits = { { bait = "Frog Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
    { fish = "Takitaro", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Minnow", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true } } },
    { fish = "Tricolored Carp", isolatable = false },
}
IsolatingBaits["Davoi, Other Waterside"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Red Terrapin", isolatable = true, baits = { { bait = "Frog Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
}
IsolatingBaits["Davoi, Pond"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Red Terrapin", isolatable = false },
}
IsolatingBaits["Den of Rancor, Misc Water"] = {
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Sabiki Rig", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Minnow", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Crayfish Paste", power = 2, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Lugworm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
}
IsolatingBaits["Den of Rancor, Pool E-8"] = {
    { fish = "Bluetail", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Crayfish Paste", power = 2, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false } } },
    { fish = "Coral Butterfly", isolatable = false },
    { fish = "Gold Lobster", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Zebra Eel", isolatable = false },
}
IsolatingBaits["Den of Rancor, Pool F-11"] = {
    { fish = "Bluetail", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Ball of Crayfish Paste", power = 2, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false } } },
    { fish = "Coral Butterfly", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Ryugu Titan", isolatable = false },
}
IsolatingBaits["Dragon's Aery, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Crescent Fish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = true, baits = { { bait = "Ball of Insect Paste", power = 3, lure = false } } },
}
IsolatingBaits["East Ronfaure, Whole Zone"] = {
    { fish = "Cheval Salmon", isolatable = false },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Gold Carp", isolatable = false },
    { fish = "Shining Trout", isolatable = false },
    { fish = "Tricolored Carp", isolatable = false },
}
IsolatingBaits["East Sarutabaruta, Lake Tepokalipuka"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Crescent Fish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = true, baits = { { bait = "Ball of Insect Paste", power = 3, lure = false } } },
    { fish = "Monke-Onke", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true } } },
    { fish = "Pipira", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Meatball", power = 2, lure = false } } },
}
IsolatingBaits["East Sarutabaruta, Other Waterside (rivers)"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["East Sarutabaruta, Other Waterside (south)"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["East Sarutabaruta, Other Waterside (west)"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["East Sarutabaruta, Seaside"] = {
    { fish = "Bastore Bream", isolatable = true, baits = { { bait = "Ball of Crayfish Paste", power = 2, lure = false } } },
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Bladefish", isolatable = true, baits = { { bait = "Meatball", power = 3, lure = false }, { bait = "Slice Of Bluetail", power = 3, lure = false } } },
    { fish = "Bluetail", isolatable = false },
    { fish = "Gold Lobster", isolatable = false },
    { fish = "Ogre Eel", isolatable = false },
    { fish = "Quus", isolatable = false },
}
IsolatingBaits["Eastern Altepa Desert, Whole Zone"] = {
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = false },
    { fish = "Giant Donko", isolatable = true, baits = { { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Sandfish", isolatable = true, baits = { { bait = "Sabiki Rig", power = 2, lure = true } } },
}
IsolatingBaits["Ghelsba Outpost, Pond North"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Sinking Minnow", power = 3, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Red Terrapin", isolatable = true, baits = { { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
}
IsolatingBaits["Ghelsba Outpost, Pond South"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Sinking Minnow", power = 3, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Red Terrapin", isolatable = true, baits = { { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
}
IsolatingBaits["Ghelsba Outpost, River"] = {
    { fish = "Cheval Salmon", isolatable = false },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Gold Carp", isolatable = false },
    { fish = "Shining Trout", isolatable = false },
    { fish = "Tricolored Carp", isolatable = false },
}
IsolatingBaits["Giddeus, Giddeus Spring"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 3, lure = false }, { bait = "Ball of Trout Paste", power = 3, lure = false }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
    { fish = "Monke-Onke", isolatable = false },
    { fish = "Tricolored Carp", isolatable = false },
}
IsolatingBaits["Giddeus, Misc Puddles"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Giddeus, Pond - North"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Red Terrapin", isolatable = false },
    { fish = "Tricolored Carp", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true } } },
}
IsolatingBaits["Giddeus, Pond - West"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 3, lure = false }, { bait = "Ball of Trout Paste", power = 3, lure = false }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
    { fish = "Tricolored Carp", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true } } },
}
IsolatingBaits["Gusgen Mines, Interior Pool Center"] = {
    { fish = "Black Eel", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Crayfish Paste", power = 3, lure = false }, { bait = "Shell Bug", power = 3, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false } } },
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = false },
    { fish = "Gavial Fish", isolatable = true, baits = { { bait = "Lizard Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Minnow", power = 2, lure = true }, { bait = "Meatball", power = 3, lure = false } } },
    { fish = "Gold Carp", isolatable = false },
    { fish = "Tricolored Carp", isolatable = false },
}
IsolatingBaits["Gusgen Mines, Interior Pool East"] = {
    { fish = "Black Eel", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Crayfish Paste", power = 3, lure = false }, { bait = "Shell Bug", power = 3, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false } } },
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = false },
    { fish = "Gavial Fish", isolatable = true, baits = { { bait = "Lizard Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Minnow", power = 2, lure = true }, { bait = "Meatball", power = 3, lure = false } } },
    { fish = "Gold Carp", isolatable = false },
    { fish = "Tricolored Carp", isolatable = false },
}
IsolatingBaits["Gusgen Mines, Interior Pool West"] = {
    { fish = "Black Eel", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Crayfish Paste", power = 3, lure = false }, { bait = "Shell Bug", power = 3, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false } } },
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = false },
    { fish = "Gavial Fish", isolatable = true, baits = { { bait = "Lizard Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Minnow", power = 2, lure = true }, { bait = "Meatball", power = 3, lure = false } } },
    { fish = "Gold Carp", isolatable = false },
    { fish = "Tricolored Carp", isolatable = false },
}
IsolatingBaits["Gusgen Mines, Pool Lower East"] = {
    { fish = "Black Eel", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Crayfish Paste", power = 3, lure = false }, { bait = "Shell Bug", power = 3, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false } } },
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Tricolored Carp", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false } } },
}
IsolatingBaits["Gusgen Mines, Pool Upper East"] = {
    { fish = "Black Eel", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Crayfish Paste", power = 3, lure = false }, { bait = "Shell Bug", power = 3, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false } } },
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Tricolored Carp", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false } } },
}
IsolatingBaits["Gusgen Mines, Pool Upper West"] = {
    { fish = "Black Eel", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Crayfish Paste", power = 3, lure = false }, { bait = "Shell Bug", power = 3, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false } } },
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Tricolored Carp", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false } } },
}
IsolatingBaits["Jugner Forest, Crystalwater Spring"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true } } },
    { fish = "Crystal Bass", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Sinking Minnow", power = 3, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Red Terrapin", isolatable = true, baits = { { bait = "Shell Bug", power = 2, lure = false } } },
}
IsolatingBaits["Jugner Forest, Lake Mechieume - Main"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Gold Carp", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Red Terrapin", isolatable = false },
    { fish = "Tricolored Carp", isolatable = false },
}
IsolatingBaits["Jugner Forest, Lake Mechieume - Mouth"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Meatball", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
    { fish = "Emperor Fish", isolatable = false },
    { fish = "Gold Carp", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Tricolored Carp", isolatable = false },
}
IsolatingBaits["Jugner Forest, Maidens Spring"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Red Terrapin", isolatable = true, baits = { { bait = "Frog Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
}
IsolatingBaits["Jugner Forest, River"] = {
    { fish = "Cheval Salmon", isolatable = false },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Gold Carp", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Shining Trout", isolatable = false },
    { fish = "Tricolored Carp", isolatable = false },
}
IsolatingBaits["Kazham, Whole Zone"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Minnow", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Crayfish Paste", power = 2, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Coral Butterfly", isolatable = false },
    { fish = "Quus", isolatable = false },
}
IsolatingBaits["Korroloka Tunnel, Fresh Water"] = {
    { fish = "Quus", isolatable = true, baits = { { bait = "Sabiki Rig", power = 2, lure = true }, { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Lugworm", power = 3, lure = false } } },
}
IsolatingBaits["Korroloka Tunnel, Salt Water"] = {
    { fish = "Black Eel", isolatable = true, baits = { { bait = "Ball of Crayfish Paste", power = 3, lure = false }, { bait = "Shell Bug", power = 3, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false } } },
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Sandfish", isolatable = true, baits = { { bait = "Sabiki Rig", power = 2, lure = true } } },
}
IsolatingBaits["Kuftal Tunnel, Whole Zone"] = {
    { fish = "Cave Cherax", isolatable = true, baits = { { bait = "Minnow", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Meatball", power = 3, lure = false }, { bait = "Piece of Rotten Meat", power = 3, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false } } },
    { fish = "Giant Donko", isolatable = true, baits = { { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false } } },
    { fish = "Sandfish", isolatable = true, baits = { { bait = "Sabiki Rig", power = 2, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false } } },
}
IsolatingBaits["La Theine Plateau, Whole Zone"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Red Terrapin", isolatable = false },
}
IsolatingBaits["Lower Jeuno, Whole Zone"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Black Sole", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Minnow", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Nosteau Herring", isolatable = false },
    { fish = "Tiger Cod", isolatable = false },
    { fish = "Yellow Globe", isolatable = false },
}
IsolatingBaits["Lufaise Meadows, Leremieu Lagoon"] = {
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Emperor Fish", isolatable = false },
    { fish = "Lik", isolatable = true, baits = { { bait = "Dwarf Pugil", power = 2, lure = false } } },
    { fish = "Tavnazian Goby", isolatable = true, baits = { { bait = "Little Worm", power = 2, lure = false } } },
}
IsolatingBaits["Lufaise Meadows, Rafeloux River"] = {
    { fish = "Gold Carp", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true }, { bait = "Robber Rig", power = 1, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false } } },
    { fish = "Tavnazian Goby", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Shell Bug", power = 2, lure = false } } },
}
IsolatingBaits["Lufaise Meadows, Seaside"] = {
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false } } },
    { fish = "Greedie", isolatable = false },
    { fish = "Quus", isolatable = false },
}
IsolatingBaits["Mamook, Other Waterside"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Mamook, Pond"] = {
    { fish = "Alabaligi", isolatable = false },
    { fish = "Betta", isolatable = false },
    { fish = "Kayabaligi", isolatable = false },
    { fish = "Sazanbaligi", isolatable = true, baits = { { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false } } },
    { fish = "Yilanbaligi", isolatable = true, baits = { { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Manaclipper, Dhalmel Rock"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Bibikibo", isolatable = false },
    { fish = "Bladefish", isolatable = false },
    { fish = "Bluetail", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Little Worm", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false } } },
    { fish = "Cone Calamary", isolatable = false },
    { fish = "Gugru Tuna", isolatable = false },
    { fish = "Gugrusaurus", isolatable = true, baits = { { bait = "Drill Calamary", power = 2, lure = false } } },
    { fish = "Moorish Idol", isolatable = false },
    { fish = "Noble Lady", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Ryugu Titan", isolatable = false },
    { fish = "Titanic Sawfish", isolatable = false },
    { fish = "Titanictus", isolatable = false },
    { fish = "Trilobite", isolatable = false },
    { fish = "Vongola Clam", isolatable = false },
    { fish = "Zafmlug Bass", isolatable = false },
}
IsolatingBaits["Mhaura, Whole Zone"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Yellow Globe", isolatable = true, baits = { { bait = "Worm Lure", power = 3, lure = true }, { bait = "Ball of Crayfish Paste", power = 3, lure = false } } },
}
IsolatingBaits["Misareaux Coast, Cascade Edellaine"] = {
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 3, lure = false }, { bait = "Ball of Trout Paste", power = 3, lure = false }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false } } },
    { fish = "Gold Carp", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Takitaro", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true } } },
    { fish = "Tavnazian Goby", isolatable = false },
}
IsolatingBaits["Misareaux Coast, Rafeloux River"] = {
    { fish = "Gold Carp", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true }, { bait = "Robber Rig", power = 1, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false } } },
    { fish = "Tavnazian Goby", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Shell Bug", power = 2, lure = false } } },
}
IsolatingBaits["Misareaux Coast, Seaside"] = {
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false } } },
    { fish = "Greedie", isolatable = false },
    { fish = "Quus", isolatable = false },
}
IsolatingBaits["Mount Zhayolm, Whole Zone"] = {
    { fish = "Denizanasi", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Crayfish Paste", power = 2, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Hamsi", isolatable = false },
    { fish = "Kalamar", isolatable = false },
}
IsolatingBaits["Nashmau, Whole Zone"] = {
    { fish = "Ahtapot", isolatable = false },
    { fish = "Istakoz", isolatable = false },
    { fish = "Istiridye", isolatable = false },
    { fish = "Mercanbaligi", isolatable = false },
    { fish = "Pterygotus", isolatable = true, baits = { { bait = "Lugworm", power = 3, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
}
IsolatingBaits["Norg, Whole Zone"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Minnow", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Coral Butterfly", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Yellow Globe", isolatable = false },
}
IsolatingBaits["North Gustaberg, Basin of Waterfall"] = {
    { fish = "Black Eel", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Crayfish Paste", power = 3, lure = false }, { bait = "Shell Bug", power = 3, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false } } },
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = false },
    { fish = "Gavial Fish", isolatable = true, baits = { { bait = "Lizard Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Minnow", power = 2, lure = true }, { bait = "Meatball", power = 3, lure = false } } },
    { fish = "Gold Carp", isolatable = false },
    { fish = "Tricolored Carp", isolatable = false },
}
IsolatingBaits["North Gustaberg, River"] = {
    { fish = "Black Eel", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Crayfish Paste", power = 3, lure = false }, { bait = "Shell Bug", power = 3, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false } } },
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Gold Carp", isolatable = false },
    { fish = "Tricolored Carp", isolatable = false },
}
IsolatingBaits["Northern San d'Oria, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Gold Carp", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Tricolored Carp", isolatable = false },
}
IsolatingBaits["Oldton Movalpolos, Whole Zone"] = {
    { fish = "Armored Pisces", isolatable = true, baits = { { bait = "Frog Lure", power = 3, lure = true }, { bait = "Minnow", power = 3, lure = true }, { bait = "Sinking Minnow", power = 3, lure = true } } },
    { fish = "Black Eel", isolatable = true, baits = { { bait = "Ball of Crayfish Paste", power = 3, lure = false } } },
    { fish = "Blindfish", isolatable = true, baits = { { bait = "Ball of Insect Paste", power = 3, lure = false } } },
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Open sea route to Al Zahbi, Whole Zone"] = {
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false } } },
    { fish = "Gugru Tuna", isolatable = false },
    { fish = "Gugrusaurus", isolatable = true, baits = { { bait = "Drill Calamary", power = 2, lure = false } } },
    { fish = "Gurnard", isolatable = false },
    { fish = "Mola Mola", isolatable = false },
    { fish = "Noble Lady", isolatable = false },
    { fish = "Veydal Wrasse", isolatable = false },
    { fish = "Yellow Globe", isolatable = false },
}
IsolatingBaits["Open sea route to Mhaura, Whole Zone"] = {
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false } } },
    { fish = "Gugru Tuna", isolatable = false },
    { fish = "Gugrusaurus", isolatable = true, baits = { { bait = "Drill Calamary", power = 2, lure = false } } },
    { fish = "Gurnard", isolatable = false },
    { fish = "Mola Mola", isolatable = false },
    { fish = "Noble Lady", isolatable = false },
    { fish = "Veydal Wrasse", isolatable = false },
    { fish = "Yellow Globe", isolatable = false },
}
IsolatingBaits["Ordelle's Caves, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Palborough Mines, Whole Zone"] = {
    { fish = "Black Eel", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Crayfish Paste", power = 3, lure = false }, { bait = "Shell Bug", power = 3, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false } } },
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Tricolored Carp", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true }, { bait = "Ball of Insect Paste", power = 2, lure = false } } },
}
IsolatingBaits["Pashhow Marshlands, Whole Zone"] = {
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Lufaise Fly", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Sinking Minnow", power = 3, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Red Terrapin", isolatable = true, baits = { { bait = "Shell Bug", power = 2, lure = false } } },
}
IsolatingBaits["Phanauet Channel, Whole Zone"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Gold Carp", isolatable = false },
    { fish = "Lungfish", isolatable = false },
    { fish = "Muddy Siredon", isolatable = false },
    { fish = "Phanauet Newt", isolatable = false },
    { fish = "Red Terrapin", isolatable = false },
    { fish = "Shining Trout", isolatable = false },
    { fish = "Tricolored Carp", isolatable = false },
    { fish = "Tricorn", isolatable = false },
}
IsolatingBaits["Phomiuna Aqueducts, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Port Bastok, Whole Zone"] = {
    { fish = "Bastore Bream", isolatable = false },
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false } } },
    { fish = "Quus", isolatable = false },
    { fish = "Zafmlug Bass", isolatable = false },
}
IsolatingBaits["Port Jeuno, Whole Zone"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Black Sole", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Minnow", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Nosteau Herring", isolatable = false },
    { fish = "Tiger Cod", isolatable = false },
    { fish = "Yellow Globe", isolatable = false },
}
IsolatingBaits["Port San d'Oria, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Sinking Minnow", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Gold Carp", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Tricolored Carp", isolatable = false },
}
IsolatingBaits["Port Windurst, Whole Zone"] = {
    { fish = "Bastore Bream", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true }, { bait = "Minnow", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Ball of Crayfish Paste", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Quus", isolatable = false },
}
IsolatingBaits["Qufim Island, Northwest Seaside"] = {
    { fish = "Black Sole", isolatable = true, baits = { { bait = "Sinking Minnow", power = 3, lure = true }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Bluetail", isolatable = true, baits = { { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Cone Calamary", isolatable = false },
    { fish = "Gigant Squid", isolatable = false },
    { fish = "Nosteau Herring", isolatable = true, baits = { { bait = "Ball of Sardine Paste", power = 2, lure = false } } },
    { fish = "Tiger Cod", isolatable = false },
    { fish = "Yellow Globe", isolatable = true, baits = { { bait = "Worm Lure", power = 3, lure = true } } },
}
IsolatingBaits["Qufim Island, Other Seaside"] = {
    { fish = "Black Sole", isolatable = true, baits = { { bait = "Sinking Minnow", power = 3, lure = true }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false } } },
    { fish = "Bluetail", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Nosteau Herring", isolatable = true, baits = { { bait = "Ball of Sardine Paste", power = 2, lure = false } } },
    { fish = "Tiger Cod", isolatable = false },
    { fish = "Yellow Globe", isolatable = true, baits = { { bait = "Sabiki Rig", power = 3, lure = true }, { bait = "Worm Lure", power = 3, lure = true } } },
}
IsolatingBaits["Qufim Island, Southwest Seaside"] = {
    { fish = "Black Sole", isolatable = true, baits = { { bait = "Sinking Minnow", power = 3, lure = true }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Bluetail", isolatable = true, baits = { { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Nosteau Herring", isolatable = true, baits = { { bait = "Ball of Sardine Paste", power = 2, lure = false } } },
    { fish = "Three-eyed Fish", isolatable = false },
    { fish = "Tiger Cod", isolatable = false },
    { fish = "Yellow Globe", isolatable = true, baits = { { bait = "Sabiki Rig", power = 3, lure = true }, { bait = "Worm Lure", power = 3, lure = true } } },
}
IsolatingBaits["Quicksand Caves, Whole Zone"] = {
    { fish = "Cave Cherax", isolatable = true, baits = { { bait = "Minnow", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Meatball", power = 3, lure = false }, { bait = "Piece of Rotten Meat", power = 3, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false } } },
}
IsolatingBaits["Rabao, Whole Zone"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Giant Donko", isolatable = true, baits = { { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Sandfish", isolatable = true, baits = { { bait = "Sabiki Rig", power = 2, lure = true } } },
}
IsolatingBaits["Ranguemont Pass, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Rolanberry Fields, Fountain of Partings"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Red Terrapin", isolatable = false },
}
IsolatingBaits["Rolanberry Fields, Fountain of Promises"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Meatball", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Red Terrapin", isolatable = false },
}
IsolatingBaits["Rolanberry Fields, Small Fountain 1"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = true, baits = { { bait = "Ball of Insect Paste", power = 3, lure = false } } },
    { fish = "Red Terrapin", isolatable = true, baits = { { bait = "Frog Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
}
IsolatingBaits["Rolanberry Fields, Small Fountain 2"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = true, baits = { { bait = "Ball of Insect Paste", power = 3, lure = false } } },
    { fish = "Red Terrapin", isolatable = true, baits = { { bait = "Frog Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
}
IsolatingBaits["Ru'Aun Gardens, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Sauromugue Champaign, Whole Zone"] = {
    { fish = "Black Sole", isolatable = true, baits = { { bait = "Sinking Minnow", power = 3, lure = true }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Bluetail", isolatable = true, baits = { { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Cone Calamary", isolatable = false },
    { fish = "Silver Shark", isolatable = true, baits = { { bait = "Meatball", power = 3, lure = false } } },
    { fish = "Tiger Cod", isolatable = false },
    { fish = "Yellow Globe", isolatable = true, baits = { { bait = "Worm Lure", power = 3, lure = true } } },
}
IsolatingBaits["Sea Serpent Grotto, Interior of Hidden Door - Gold"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Minnow", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Crayfish Paste", power = 2, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Coral Butterfly", isolatable = false },
    { fish = "Quus", isolatable = false },
}
IsolatingBaits["Sea Serpent Grotto, Interior of Hidden Door - Mythril"] = {
    { fish = "Bastore Bream", isolatable = false },
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Bluetail", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false } } },
    { fish = "Coral Butterfly", isolatable = false },
    { fish = "Grimmonite", isolatable = false },
    { fish = "Nebimonite", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Silver Shark", isolatable = false },
}
IsolatingBaits["Sea Serpent Grotto, Misc Puddles"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Minnow", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Crayfish Paste", power = 2, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Quus", isolatable = false },
}
IsolatingBaits["Sea Serpent Grotto, Other Seaside"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Minnow", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Crayfish Paste", power = 2, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Coral Butterfly", isolatable = false },
    { fish = "Quus", isolatable = false },
}
IsolatingBaits["Sea Serpent Grotto, Pond Under a Bridge"] = {
    { fish = "Bastore Bream", isolatable = false },
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Bluetail", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false } } },
    { fish = "Coral Butterfly", isolatable = false },
    { fish = "Grimmonite", isolatable = false },
    { fish = "Nebimonite", isolatable = false },
    { fish = "Quus", isolatable = false },
}
IsolatingBaits["Selbina, Whole Zone"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false } } },
    { fish = "Fat Greedie", isolatable = false },
    { fish = "Greedie", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Zafmlug Bass", isolatable = false },
}
IsolatingBaits["Ship bound for Mhaura (with Pirates), Whole Zone"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Bhefhel Marlin", isolatable = false },
    { fish = "Bluetail", isolatable = false },
    { fish = "Cone Calamary", isolatable = false },
    { fish = "Gugru Tuna", isolatable = false },
    { fish = "Gugrusaurus", isolatable = false },
    { fish = "Nebimonite", isolatable = true, baits = { { bait = "Ball of Crayfish Paste", power = 3, lure = false } } },
    { fish = "Noble Lady", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Ryugu Titan", isolatable = true, baits = { { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true } } },
    { fish = "Sea Zombie", isolatable = true, baits = { { bait = "Piece of Rotten Meat", power = 1, lure = false } } },
    { fish = "Silver Shark", isolatable = false },
    { fish = "Titanictus", isolatable = false },
}
IsolatingBaits["Ship bound for Mhaura, Whole Zone"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Bhefhel Marlin", isolatable = false },
    { fish = "Bluetail", isolatable = false },
    { fish = "Cone Calamary", isolatable = false },
    { fish = "Gugru Tuna", isolatable = false },
    { fish = "Nebimonite", isolatable = true, baits = { { bait = "Ball of Crayfish Paste", power = 3, lure = false } } },
    { fish = "Noble Lady", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Ryugu Titan", isolatable = true, baits = { { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true } } },
    { fish = "Silver Shark", isolatable = false },
    { fish = "Titanictus", isolatable = false },
}
IsolatingBaits["Ship bound for Selbina (with Pirates), Whole Zone"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Bhefhel Marlin", isolatable = false },
    { fish = "Bluetail", isolatable = false },
    { fish = "Cone Calamary", isolatable = false },
    { fish = "Gugru Tuna", isolatable = false },
    { fish = "Gugrusaurus", isolatable = false },
    { fish = "Nebimonite", isolatable = true, baits = { { bait = "Ball of Crayfish Paste", power = 3, lure = false } } },
    { fish = "Noble Lady", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Ryugu Titan", isolatable = true, baits = { { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true } } },
    { fish = "Sea Zombie", isolatable = true, baits = { { bait = "Piece of Rotten Meat", power = 1, lure = false } } },
    { fish = "Silver Shark", isolatable = false },
    { fish = "Titanictus", isolatable = false },
}
IsolatingBaits["Ship bound for Selbina, Whole Zone"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Bhefhel Marlin", isolatable = false },
    { fish = "Bluetail", isolatable = false },
    { fish = "Cone Calamary", isolatable = false },
    { fish = "Gugru Tuna", isolatable = false },
    { fish = "Nebimonite", isolatable = true, baits = { { bait = "Ball of Crayfish Paste", power = 3, lure = false } } },
    { fish = "Noble Lady", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Ryugu Titan", isolatable = true, baits = { { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true } } },
    { fish = "Silver Shark", isolatable = false },
    { fish = "Titanictus", isolatable = false },
}
IsolatingBaits["Silver Sea route to Al Zahbi, Whole Zone"] = {
    { fish = "Hamsi", isolatable = true, baits = { { bait = "Lugworm", power = 2, lure = false } } },
    { fish = "Kalamar", isolatable = false },
    { fish = "Kalkanbaligi", isolatable = true, baits = { { bait = "Ball of Crayfish Paste", power = 2, lure = false } } },
    { fish = "Kilicbaligi", isolatable = true, baits = { { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Peeled Lobster", power = 2, lure = false } } },
    { fish = "Lakerda", isolatable = false },
    { fish = "Uskumru", isolatable = false },
}
IsolatingBaits["Silver Sea route to Nashmau, Whole Zone"] = {
    { fish = "Hamsi", isolatable = true, baits = { { bait = "Lugworm", power = 2, lure = false } } },
    { fish = "Kalamar", isolatable = false },
    { fish = "Kalkanbaligi", isolatable = true, baits = { { bait = "Ball of Crayfish Paste", power = 2, lure = false } } },
    { fish = "Kilicbaligi", isolatable = true, baits = { { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Peeled Lobster", power = 2, lure = false } } },
    { fish = "Lakerda", isolatable = false },
    { fish = "Uskumru", isolatable = false },
}
IsolatingBaits["South Gustaberg, Seaside"] = {
    { fish = "Bastore Bream", isolatable = false },
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Bladefish", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false } } },
    { fish = "Gold Lobster", isolatable = false },
    { fish = "Ogre Eel", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Zafmlug Bass", isolatable = false },
}
IsolatingBaits["Talacca Cove, Whole Zone"] = {
    { fish = "Ahtapot", isolatable = false },
    { fish = "Dil", isolatable = true, baits = { { bait = "Slice Of Cod", power = 3, lure = false } } },
    { fish = "Istakoz", isolatable = false },
    { fish = "Istavrit", isolatable = true, baits = { { bait = "Lugworm", power = 3, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
    { fish = "Mercanbaligi", isolatable = false },
}
IsolatingBaits["Tavnazian Safehold, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Temple of Uggalepih, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = true, baits = { { bait = "Ball of Insect Paste", power = 3, lure = false } } },
}
IsolatingBaits["The Boyahda Tree, Other Waterside"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 3, lure = false }, { bait = "Ball of Trout Paste", power = 3, lure = false }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
}
IsolatingBaits["The Boyahda Tree, Waterfall Basin"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
    { fish = "Giant Chirai", isolatable = true, baits = { { bait = "Fly Lure", power = 2, lure = true }, { bait = "Lufaise Fly", power = 3, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Tricolored Carp", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true } } },
}
IsolatingBaits["The Boyahda Tree, Waterfall Basin - Hidden"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Meatball", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
    { fish = "Emperor Fish", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Tricolored Carp", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true } } },
}
IsolatingBaits["The Sanctuary of Zi'Tah, Whole Zone"] = {
    { fish = "Crystal Bass", isolatable = true, baits = { { bait = "Little Worm", power = 2, lure = false } } },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true } } },
    { fish = "Red Terrapin", isolatable = false },
}
IsolatingBaits["The Shrine of Ru'Avitau, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Valkurm Dunes, Whole Zone"] = {
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Cobalt Jellyfish", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Shrimp Lure", power = 2, lure = true }, { bait = "Little Worm", power = 3, lure = false }, { bait = "Meatball", power = 3, lure = false }, { bait = "Ball of Insect Paste", power = 2, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false }, { bait = "Peeled Lobster", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false }, { bait = "Slice Of Bluetail", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false }, { bait = "Slice Of Cod", power = 2, lure = false } } },
    { fish = "Greedie", isolatable = false },
    { fish = "Quus", isolatable = false },
    { fish = "Shall Shell", isolatable = false },
    { fish = "Zafmlug Bass", isolatable = false },
}
IsolatingBaits["Wajaom Woodlands, Whole Zone"] = {
    { fish = "Alabaligi", isolatable = true, baits = { { bait = "Fly Lure", power = 2, lure = true } } },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false }, { bait = "Slice Of Carp", power = 2, lure = false } } },
    { fish = "Kayabaligi", isolatable = false },
    { fish = "Morinabaligi", isolatable = false },
    { fish = "Sazanbaligi", isolatable = false },
    { fish = "Turnabaligi", isolatable = false },
    { fish = "Yilanbaligi", isolatable = false },
}
IsolatingBaits["West Ronfaure, Knightwell"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Sinking Minnow", power = 3, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = true, baits = { { bait = "Ball of Insect Paste", power = 3, lure = false } } },
    { fish = "Red Terrapin", isolatable = true, baits = { { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
}
IsolatingBaits["West Sarutabaruta, Pond"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Dark Bass", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Meatball", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
}
IsolatingBaits["West Sarutabaruta, Seaside"] = {
    { fish = "Bastore Bream", isolatable = true, baits = { { bait = "Ball of Crayfish Paste", power = 2, lure = false } } },
    { fish = "Bastore Sardine", isolatable = false },
    { fish = "Bladefish", isolatable = true, baits = { { bait = "Meatball", power = 3, lure = false }, { bait = "Slice Of Bluetail", power = 3, lure = false } } },
    { fish = "Bluetail", isolatable = false },
    { fish = "Gold Lobster", isolatable = false },
    { fish = "Ogre Eel", isolatable = false },
    { fish = "Quus", isolatable = false },
}
IsolatingBaits["Western Altepa Desert, Central Spring"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Sinking Minnow", power = 3, lure = true }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Giant Donko", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Sandfish", isolatable = true, baits = { { bait = "Sabiki Rig", power = 2, lure = true } } },
}
IsolatingBaits["Western Altepa Desert, Oasis of Hubol"] = {
    { fish = "Crayfish", isolatable = false },
    { fish = "Gavial Fish", isolatable = true, baits = { { bait = "Meatball", power = 3, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Sinking Minnow", power = 3, lure = true }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Giant Donko", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Sandfish", isolatable = true, baits = { { bait = "Sabiki Rig", power = 2, lure = true } } },
}
IsolatingBaits["Windurst Walls, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Gold Carp", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Pipira", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Meatball", power = 2, lure = false } } },
}
IsolatingBaits["Windurst Waters, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Gold Carp", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Pipira", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Meatball", power = 2, lure = false } } },
}
IsolatingBaits["Windurst Woods, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Gold Carp", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Pipira", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Meatball", power = 2, lure = false } } },
}
IsolatingBaits["Yhoator Jungle, Bloodlet Spring"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Forest Carp", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
}
IsolatingBaits["Yhoator Jungle, Front of Temple - East Side"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Elshimo Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true } } },
    { fish = "Forest Carp", isolatable = false },
    { fish = "Jungle Catfish", isolatable = true, baits = { { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 3, lure = false }, { bait = "Ball of Trout Paste", power = 3, lure = false }, { bait = "Piece of Rotten Meat", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Pipira", isolatable = false },
}
IsolatingBaits["Yhoator Jungle, Front of Temple - West Side"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Elshimo Frog", isolatable = false },
    { fish = "Elshimo Newt", isolatable = false },
    { fish = "Forest Carp", isolatable = false },
    { fish = "Jungle Catfish", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 3, lure = false }, { bait = "Ball of Trout Paste", power = 3, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
}
IsolatingBaits["Yhoator Jungle, Teardrop Spring"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Forest Carp", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
}
IsolatingBaits["Yhoator Jungle, Underground Pool 1"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false } } },
    { fish = "Forest Carp", isolatable = false },
    { fish = "Jungle Catfish", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 3, lure = false }, { bait = "Ball of Trout Paste", power = 3, lure = false }, { bait = "Meatball", power = 2, lure = false }, { bait = "Piece of Rotten Meat", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Monke-Onke", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true } } },
}
IsolatingBaits["Yhoator Jungle, Underground Pool 2"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Elshimo Frog", isolatable = false },
    { fish = "Elshimo Newt", isolatable = true, baits = { { bait = "Frog Lure", power = 3, lure = true }, { bait = "Meatball", power = 2, lure = false }, { bait = "Piece of Rotten Meat", power = 2, lure = false } } },
    { fish = "Forest Carp", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
}
IsolatingBaits["Yhoator Jungle, Underground Pool 3"] = {
    { fish = "Elshimo Frog", isolatable = false },
    { fish = "Elshimo Newt", isolatable = true, baits = { { bait = "Frog Lure", power = 3, lure = true }, { bait = "Meatball", power = 2, lure = false }, { bait = "Piece of Rotten Meat", power = 2, lure = false } } },
}
IsolatingBaits["Yughott Grotto, Whole Zone"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Robber Rig", power = 1, lure = true }, { bait = "Rogue Rig", power = 1, lure = true }, { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Little Worm", power = 2, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Yuhtunga Jungle, Gremini Falls"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Crescent Fish", isolatable = true, baits = { { bait = "Giant Shell Bug", power = 2, lure = false } } },
    { fish = "Elshimo Frog", isolatable = false },
    { fish = "Elshimo Newt", isolatable = true, baits = { { bait = "Frog Lure", power = 3, lure = true }, { bait = "Meatball", power = 2, lure = false }, { bait = "Piece of Rotten Meat", power = 2, lure = false } } },
    { fish = "Forest Carp", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
}
IsolatingBaits["Yuhtunga Jungle, Northeast Pond"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false } } },
    { fish = "Crescent Fish", isolatable = true, baits = { { bait = "Giant Shell Bug", power = 2, lure = false } } },
    { fish = "Elshimo Frog", isolatable = false },
    { fish = "Forest Carp", isolatable = false },
    { fish = "Jungle Catfish", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 3, lure = false }, { bait = "Ball of Trout Paste", power = 3, lure = false }, { bait = "Meatball", power = 2, lure = false }, { bait = "Piece of Rotten Meat", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Monke-Onke", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true } } },
}
IsolatingBaits["Yuhtunga Jungle, Other Waterside"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Elshimo Frog", isolatable = false },
    { fish = "Elshimo Newt", isolatable = true, baits = { { bait = "Frog Lure", power = 3, lure = true }, { bait = "Meatball", power = 2, lure = false }, { bait = "Piece of Rotten Meat", power = 2, lure = false } } },
    { fish = "Forest Carp", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
}
IsolatingBaits["Yuhtunga Jungle, Southwest Pond"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Elshimo Newt", isolatable = true, baits = { { bait = "Fly Lure", power = 2, lure = true } } },
    { fish = "Forest Carp", isolatable = false },
    { fish = "Jungle Catfish", isolatable = true, baits = { { bait = "Sinking Minnow", power = 2, lure = true }, { bait = "Ball of Sardine Paste", power = 3, lure = false }, { bait = "Ball of Trout Paste", power = 3, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Pipira", isolatable = false },
}
IsolatingBaits["Yuhtunga Jungle, Southwest Waterfall - North"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Elshimo Newt", isolatable = true, baits = { { bait = "Fly Lure", power = 2, lure = true }, { bait = "Piece of Rotten Meat", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
    { fish = "Forest Carp", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Pipira", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true } } },
}
IsolatingBaits["Yuhtunga Jungle, Southwest Waterfall - South"] = {
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Elshimo Newt", isolatable = true, baits = { { bait = "Fly Lure", power = 2, lure = true }, { bait = "Piece of Rotten Meat", power = 2, lure = false }, { bait = "Shell Bug", power = 2, lure = false } } },
    { fish = "Forest Carp", isolatable = false },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Pipira", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Worm Lure", power = 2, lure = true } } },
}
IsolatingBaits["Zeruhn Mines, Pool"] = {
    { fish = "Black Eel", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Crayfish Paste", power = 3, lure = false }, { bait = "Shell Bug", power = 3, lure = false }, { bait = "Ball of Sardine Paste", power = 2, lure = false }, { bait = "Ball of Trout Paste", power = 2, lure = false } } },
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
}
IsolatingBaits["Zeruhn Mines, River"] = {
    { fish = "Black Eel", isolatable = true, baits = { { bait = "Worm Lure", power = 2, lure = true }, { bait = "Ball of Crayfish Paste", power = 3, lure = false }, { bait = "Shell Bug", power = 3, lure = false } } },
    { fish = "Copper Frog", isolatable = true, baits = { { bait = "Fly Lure", power = 3, lure = true }, { bait = "Giant Shell Bug", power = 2, lure = false }, { bait = "Lufaise Fly", power = 2, lure = false } } },
    { fish = "Crayfish", isolatable = true, baits = { { bait = "Slice Of Carp", power = 3, lure = false }, { bait = "Peeled Crayfish", power = 2, lure = false } } },
    { fish = "Giant Catfish", isolatable = true, baits = { { bait = "Minnow", power = 3, lure = true }, { bait = "Sinking Minnow", power = 3, lure = true }, { bait = "Frog Lure", power = 2, lure = true }, { bait = "Lizard Lure", power = 2, lure = true }, { bait = "Slice of Sardine", power = 2, lure = false } } },
    { fish = "Moat Carp", isolatable = false },
    { fish = "Tricolored Carp", isolatable = true, baits = { { bait = "Shrimp Lure", power = 3, lure = true } } },
}

local IsolatingBaitLocations = {
    "Aht Urhgan Whitegate, Whole Zone",
    "Al Zahbi, Whole Zone",
    "Arrapago Reef, Whole Zone",
    "Aydeewa Subterrane, Whole Zone",
    "Bastok Markets, North Side",
    "Bastok Markets, South Side",
    "Bastok Mines, Whole Zone",
    "Batallia Downs, North Seaside",
    "Batallia Downs, South Seaside",
    "Beaucedine Glacier, Ponds",
    "Beaucedine Glacier, Seaside",
    "Bhaflau Thickets, Whole Zone",
    "Bibiki Bay, BB - Other Seaside",
    "Bibiki Bay, BB - South Seaside",
    "Bibiki Bay, PI - East Beach",
    "Bibiki Bay, PI - North Beach",
    "Bibiki Bay, PI - South Beach",
    "Bibiki Bay, PI - West Beach",
    "Bostaunieux Oubliette, Whole Zone",
    "Buburimu Peninsula, Whole Zone",
    "Caedarva Mire, Whole Zone",
    "Cape Teriggan, Whole Zone",
    "Carpenters' Landing, Central Landing",
    "Carpenters' Landing, North Landing",
    "Carpenters' Landing, Other Waterside Center",
    "Carpenters' Landing, Other Waterside North",
    "Carpenters' Landing, Other Waterside South",
    "Carpenters' Landing, South Landing",
    "Castle Oztroja, Whole Zone",
    "Dangruf Wadi, Whole Zone",
    "Davoi, Basin of a Waterfall",
    "Davoi, Other Waterside",
    "Davoi, Pond",
    "Den of Rancor, Misc Water",
    "Den of Rancor, Pool E-8",
    "Den of Rancor, Pool F-11",
    "Dragon's Aery, Whole Zone",
    "East Ronfaure, Whole Zone",
    "East Sarutabaruta, Lake Tepokalipuka",
    "East Sarutabaruta, Other Waterside (rivers)",
    "East Sarutabaruta, Other Waterside (south)",
    "East Sarutabaruta, Other Waterside (west)",
    "East Sarutabaruta, Seaside",
    "Eastern Altepa Desert, Whole Zone",
    "Ghelsba Outpost, Pond North",
    "Ghelsba Outpost, Pond South",
    "Ghelsba Outpost, River",
    "Giddeus, Giddeus Spring",
    "Giddeus, Misc Puddles",
    "Giddeus, Pond - North",
    "Giddeus, Pond - West",
    "Gusgen Mines, Interior Pool Center",
    "Gusgen Mines, Interior Pool East",
    "Gusgen Mines, Interior Pool West",
    "Gusgen Mines, Pool Lower East",
    "Gusgen Mines, Pool Upper East",
    "Gusgen Mines, Pool Upper West",
    "Jugner Forest, Crystalwater Spring",
    "Jugner Forest, Lake Mechieume - Main",
    "Jugner Forest, Lake Mechieume - Mouth",
    "Jugner Forest, Maidens Spring",
    "Jugner Forest, River",
    "Kazham, Whole Zone",
    "Korroloka Tunnel, Fresh Water",
    "Korroloka Tunnel, Salt Water",
    "Kuftal Tunnel, Whole Zone",
    "La Theine Plateau, Whole Zone",
    "Lower Jeuno, Whole Zone",
    "Lufaise Meadows, Leremieu Lagoon",
    "Lufaise Meadows, Rafeloux River",
    "Lufaise Meadows, Seaside",
    "Mamook, Other Waterside",
    "Mamook, Pond",
    "Manaclipper, Dhalmel Rock",
    "Mhaura, Whole Zone",
    "Misareaux Coast, Cascade Edellaine",
    "Misareaux Coast, Rafeloux River",
    "Misareaux Coast, Seaside",
    "Mount Zhayolm, Whole Zone",
    "Nashmau, Whole Zone",
    "Norg, Whole Zone",
    "North Gustaberg, Basin of Waterfall",
    "North Gustaberg, River",
    "Northern San d'Oria, Whole Zone",
    "Oldton Movalpolos, Whole Zone",
    "Open sea route to Al Zahbi, Whole Zone",
    "Open sea route to Mhaura, Whole Zone",
    "Ordelle's Caves, Whole Zone",
    "Palborough Mines, Whole Zone",
    "Pashhow Marshlands, Whole Zone",
    "Phanauet Channel, Whole Zone",
    "Phomiuna Aqueducts, Whole Zone",
    "Port Bastok, Whole Zone",
    "Port Jeuno, Whole Zone",
    "Port San d'Oria, Whole Zone",
    "Port Windurst, Whole Zone",
    "Qufim Island, Northwest Seaside",
    "Qufim Island, Other Seaside",
    "Qufim Island, Southwest Seaside",
    "Quicksand Caves, Whole Zone",
    "Rabao, Whole Zone",
    "Ranguemont Pass, Whole Zone",
    "Rolanberry Fields, Fountain of Partings",
    "Rolanberry Fields, Fountain of Promises",
    "Rolanberry Fields, Small Fountain 1",
    "Rolanberry Fields, Small Fountain 2",
    "Ru'Aun Gardens, Whole Zone",
    "Sauromugue Champaign, Whole Zone",
    "Sea Serpent Grotto, Interior of Hidden Door - Gold",
    "Sea Serpent Grotto, Interior of Hidden Door - Mythril",
    "Sea Serpent Grotto, Misc Puddles",
    "Sea Serpent Grotto, Other Seaside",
    "Sea Serpent Grotto, Pond Under a Bridge",
    "Selbina, Whole Zone",
    "Ship bound for Mhaura (with Pirates), Whole Zone",
    "Ship bound for Mhaura, Whole Zone",
    "Ship bound for Selbina (with Pirates), Whole Zone",
    "Ship bound for Selbina, Whole Zone",
    "Silver Sea route to Al Zahbi, Whole Zone",
    "Silver Sea route to Nashmau, Whole Zone",
    "South Gustaberg, Seaside",
    "Talacca Cove, Whole Zone",
    "Tavnazian Safehold, Whole Zone",
    "Temple of Uggalepih, Whole Zone",
    "The Boyahda Tree, Other Waterside",
    "The Boyahda Tree, Waterfall Basin",
    "The Boyahda Tree, Waterfall Basin - Hidden",
    "The Sanctuary of Zi'Tah, Whole Zone",
    "The Shrine of Ru'Avitau, Whole Zone",
    "Valkurm Dunes, Whole Zone",
    "Wajaom Woodlands, Whole Zone",
    "West Ronfaure, Knightwell",
    "West Sarutabaruta, Pond",
    "West Sarutabaruta, Seaside",
    "Western Altepa Desert, Central Spring",
    "Western Altepa Desert, Oasis of Hubol",
    "Windurst Walls, Whole Zone",
    "Windurst Waters, Whole Zone",
    "Windurst Woods, Whole Zone",
    "Yhoator Jungle, Bloodlet Spring",
    "Yhoator Jungle, Front of Temple - East Side",
    "Yhoator Jungle, Front of Temple - West Side",
    "Yhoator Jungle, Teardrop Spring",
    "Yhoator Jungle, Underground Pool 1",
    "Yhoator Jungle, Underground Pool 2",
    "Yhoator Jungle, Underground Pool 3",
    "Yughott Grotto, Whole Zone",
    "Yuhtunga Jungle, Gremini Falls",
    "Yuhtunga Jungle, Northeast Pond",
    "Yuhtunga Jungle, Other Waterside",
    "Yuhtunga Jungle, Southwest Pond",
    "Yuhtunga Jungle, Southwest Waterfall - North",
    "Yuhtunga Jungle, Southwest Waterfall - South",
    "Zeruhn Mines, Pool",
    "Zeruhn Mines, River",
}

-- Reverse index (built once here) so the addon can offer a
-- fish-first dropdown ("pick a fish, see where it can be isolated")
-- as well as the area-first one above, without a second data dump.
local IsolatingBaitsByFish = {}
local fishNameSet = {}
local IsolatingBaitFishNames = {}

for area, entries in pairs(IsolatingBaits) do
    for _, entry in ipairs(entries) do
        if not IsolatingBaitsByFish[entry.fish] then
            IsolatingBaitsByFish[entry.fish] = {}
            fishNameSet[entry.fish] = true
        end
        table.insert(IsolatingBaitsByFish[entry.fish], {
            area = area,
            isolatable = entry.isolatable,
            baits = entry.baits,
        })
    end
end

for name in pairs(fishNameSet) do
    table.insert(IsolatingBaitFishNames, name)
end
table.sort(IsolatingBaitFishNames)

for _, areaList in pairs(IsolatingBaitsByFish) do
    table.sort(areaList, function(a, b) return a.area < b.area end)
end

return {
    data = IsolatingBaits,
    locations = IsolatingBaitLocations,
    byFish = IsolatingBaitsByFish,
    fishNames = IsolatingBaitFishNames,
}