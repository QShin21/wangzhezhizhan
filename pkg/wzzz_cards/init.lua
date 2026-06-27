-- SPDX-License-Identifier: GPL-3.0-or-later

local extension = Package:new("wzzz_cards", Package.CardPack)

-- A, 10 cards.
extension:addCardSpec("archery_attack", Card.Heart, 1)
extension:addCardSpec("god_salvation", Card.Heart, 1)
extension:addCardSpec("nullification", Card.Heart, 1)
extension:addCardSpec("duel", Card.Diamond, 1)
extension:addCardSpec("fan", Card.Diamond, 1)
extension:addCardSpec("crossbow", Card.Club, 1)
extension:addCardSpec("silver_lion", Card.Club, 1)
extension:addCardSpec("lightning", Card.Spade, 1)
extension:addCardSpec("duel", Card.Spade, 1)
extension:addCardSpec("guding_blade", Card.Spade, 1)

-- 2, 8 cards.
extension:addCardSpec("jink", Card.Heart, 2)
extension:addCardSpec("jink", Card.Heart, 2)
extension:addCardSpec("peach", Card.Diamond, 2)
extension:addCardSpec("jink", Card.Diamond, 2)
extension:addCardSpec("vine", Card.Club, 2)
extension:addCardSpec("eight_diagram", Card.Club, 2)
extension:addCardSpec("double_swords", Card.Spade, 2)
extension:addCardSpec("ice_sword", Card.Spade, 2)

-- 3, 8 cards.
extension:addCardSpec("amazing_grace", Card.Heart, 3)
extension:addCardSpec("fire_attack", Card.Heart, 3)
extension:addCardSpec("snatch", Card.Diamond, 3)
extension:addCardSpec("peach", Card.Diamond, 3)
extension:addCardSpec("slash", Card.Club, 3)
extension:addCardSpec("analeptic", Card.Club, 3)
extension:addCardSpec("dismantlement", Card.Spade, 3)
extension:addCardSpec("analeptic", Card.Spade, 3)

-- 4, 8 cards.
extension:addCardSpec("peach", Card.Heart, 4)
extension:addCardSpec("fire__slash", Card.Heart, 4)
extension:addCardSpec("snatch", Card.Diamond, 4)
extension:addCardSpec("fire__slash", Card.Diamond, 4)
extension:addCardSpec("slash", Card.Club, 4)
extension:addCardSpec("supply_shortage", Card.Club, 4)
extension:addCardSpec("dismantlement", Card.Spade, 4)
extension:addCardSpec("thunder__slash", Card.Spade, 4)

-- 5, 8 cards.
extension:addCardSpec("kylin_bow", Card.Heart, 5)
extension:addCardSpec("chitu", Card.Heart, 5)
extension:addCardSpec("axe", Card.Diamond, 5)
extension:addCardSpec("fire__slash", Card.Diamond, 5)
extension:addCardSpec("dilu", Card.Club, 5)
extension:addCardSpec("thunder__slash", Card.Club, 5)
extension:addCardSpec("blade", Card.Spade, 5)
extension:addCardSpec("thunder__slash", Card.Spade, 5)

-- 6, 8 cards.
extension:addCardSpec("indulgence", Card.Heart, 6)
extension:addCardSpec("peach", Card.Heart, 6)
extension:addCardSpec("slash", Card.Diamond, 6)
extension:addCardSpec("jink", Card.Diamond, 6)
extension:addCardSpec("slash", Card.Club, 6)
extension:addCardSpec("thunder__slash", Card.Club, 6)
extension:addCardSpec("indulgence", Card.Spade, 6)
extension:addCardSpec("thunder__slash", Card.Spade, 6)

-- 7, 8 cards.
extension:addCardSpec("ex_nihilo", Card.Heart, 7)
extension:addCardSpec("peach", Card.Heart, 7)
extension:addCardSpec("jink", Card.Diamond, 7)
extension:addCardSpec("jink", Card.Diamond, 7)
extension:addCardSpec("savage_assault", Card.Club, 7)
extension:addCardSpec("thunder__slash", Card.Club, 7)
extension:addCardSpec("savage_assault", Card.Spade, 7)
extension:addCardSpec("slash", Card.Spade, 7)

-- 8, 8 cards.
extension:addCardSpec("ex_nihilo", Card.Heart, 8)
extension:addCardSpec("peach", Card.Heart, 8)
extension:addCardSpec("jink", Card.Diamond, 8)
extension:addCardSpec("jink", Card.Diamond, 8)
extension:addCardSpec("slash", Card.Club, 8)
extension:addCardSpec("thunder__slash", Card.Club, 8)
extension:addCardSpec("slash", Card.Spade, 8)
extension:addCardSpec("slash", Card.Spade, 8)

-- 9, 8 cards.
extension:addCardSpec("peach", Card.Heart, 9)
extension:addCardSpec("jink", Card.Heart, 9)
extension:addCardSpec("jink", Card.Diamond, 9)
extension:addCardSpec("analeptic", Card.Diamond, 9)
extension:addCardSpec("slash", Card.Club, 9)
extension:addCardSpec("slash", Card.Club, 9)
extension:addCardSpec("slash", Card.Spade, 9)
extension:addCardSpec("slash", Card.Spade, 9)

-- 10, 8 cards.
extension:addCardSpec("slash", Card.Heart, 10)
extension:addCardSpec("fire__slash", Card.Heart, 10)
extension:addCardSpec("slash", Card.Diamond, 10)
extension:addCardSpec("jink", Card.Diamond, 10)
extension:addCardSpec("slash", Card.Club, 10)
extension:addCardSpec("slash", Card.Club, 10)
extension:addCardSpec("slash", Card.Spade, 10)
extension:addCardSpec("supply_shortage", Card.Spade, 10)

-- J, 8 cards.
extension:addCardSpec("ex_nihilo", Card.Heart, 11)
extension:addCardSpec("jink", Card.Heart, 11)
extension:addCardSpec("jink", Card.Diamond, 11)
extension:addCardSpec("jink", Card.Diamond, 11)
extension:addCardSpec("slash", Card.Club, 11)
extension:addCardSpec("slash", Card.Club, 11)
extension:addCardSpec("snatch", Card.Spade, 11)
extension:addCardSpec("iron_chain", Card.Spade, 11)

-- Q, 10 cards.
extension:addCardSpec("dismantlement", Card.Heart, 12)
extension:addCardSpec("lightning", Card.Heart, 12)
extension:addCardSpec("peach", Card.Diamond, 12)
extension:addCardSpec("nullification", Card.Diamond, 12)
extension:addCardSpec("fire_attack", Card.Diamond, 12)
extension:addCardSpec("collateral", Card.Club, 12)
extension:addCardSpec("nullification", Card.Club, 12)
extension:addCardSpec("iron_chain", Card.Club, 12)
extension:addCardSpec("spear", Card.Spade, 12)
extension:addCardSpec("dismantlement", Card.Spade, 12)

-- K, 8 cards.
extension:addCardSpec("zhuahuangfeidian", Card.Heart, 13)
extension:addCardSpec("jink", Card.Heart, 13)
extension:addCardSpec("slash", Card.Diamond, 13)
extension:addCardSpec("hualiu", Card.Diamond, 13)
extension:addCardSpec("collateral", Card.Club, 13)
extension:addCardSpec("iron_chain", Card.Club, 13)
extension:addCardSpec("dayuan", Card.Spade, 13)
extension:addCardSpec("nullification", Card.Spade, 13)

Fk:loadTranslationTable {
  ["wzzz_cards"] = "王者之战牌堆",
}

return extension
