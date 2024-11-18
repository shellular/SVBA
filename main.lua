----------------------------------------------
------------MOD CODE -------------------------
SMODS.Atlas {
	key = "modicon",
	path = 'icon2.png',
	px = 34,
	py = 34
}

SMODS.Atlas {
	key = "whitedeckatl",
	path = 'b_whi.png',
	px = 71,
	py = 95
}



--Populous Deck code
SMODS.Atlas({
	key = 'popdeckatl',
	path = 'b_pop.png',
	px = 71,
	py = 95
})

SMODS.Back {
	name = "Populous Deck",
	key = "popdeck",
	atlas = 'popdeckatl',
	pos = { x = 0, y = 0 },
	config = { ante_scaling = 1.5 },
	loc_txt = {
		name = "Populous Deck",
		text = {
			"Start run with only 28",
			"random {C:attention}Face Cards{}",
			"{C:red}X1.5{} base Blind size"
		},
	},
	unlocked = true,
	discovered = true,
	apply = function(self)
		G.E_MANAGER:add_event(Event({

			func = function()
				---G.GAME.starting_params.hands = G.GAME.starting_params.hands - 1
				---G.GAME.starting_params.discards = G.GAME.starting_params.discards - 4

				for _, card in ipairs(G.playing_cards) do
					if card.base.id >= 4 then
						card:remove()
					end
				end

				for _, card in ipairs(G.playing_cards) do
					RandGenerateForRank = pseudorandom_element({ 1, 2, 3 }, pseudoseed(self.key))
					if RandGenerateForRank == 1 then
						assert(SMODS.change_base(card, nil, 'King'))
					elseif RandGenerateForRank == 2 then
						assert(SMODS.change_base(card, nil, 'Queen'))
					else
						assert(SMODS.change_base(card, nil, 'Jack'))
					end
				end
				return true
			end
		}))
	end
}



--Arithmetic Deck code
SMODS.Atlas({
	key = 'arithdeckatl',
	path = 'b_ari.png',
	px = 71,
	py = 95
})

SMODS.Back {
	name = "Arithmetic Deck",
	key = "arithdeck",
	atlas = 'arithdeckatl',
	pos = { x = 0, y = 0 },
	loc_txt = {
		name = "Arithmetic Deck",
		text = {
			"All cards in deck",
			"are {C:red,T:m_mult}Mult{} cards",
			"{C:red}X2{} base Blind size",
		},
	},
	config = { ante_scaling = 2 },
	unlocked = true,
	discovered = true,
	apply = function(self)
		G.E_MANAGER:add_event(Event({

			func = function()
				---G.GAME.starting_params.hands = G.GAME.starting_params.hands - 1
				---G.GAME.starting_params.discards = G.GAME.starting_params.discards - 4

				for _, card in ipairs(G.playing_cards) do
					card:set_ability(G.P_CENTERS.m_mult, true)
				end

				return true
			end
		}))
	end
}



--White Deck code
SMODS.Atlas({
	key = 'stonedeckatl',
	path = 'b_sto.png',
	px = 71,
	py = 95
})

SMODS.Back {
	name = "Ancient Deck",
	key = "stonedeck",
	atlas = 'stonedeckatl',
	pos = { x = 0, y = 0 },
	loc_txt = {
		name = "Ancient Deck",
		text = {
			"All {C:attention}Face Cards{} are replaced",
			"with {C:enhanced,T:m_stone}Stone Cards{}",
		},
	},
	config = {},
	unlocked = true,
	discovered = true,
	apply = function(self)
		G.E_MANAGER:add_event(Event({

			func = function()
				for _, card in ipairs(G.playing_cards) do
					if card:get_id() == 11 or
						card:get_id() == 12 or
						card:get_id() == 13 then
						card:set_ability(G.P_CENTERS.m_stone, nil, true)
					end
				end
				return true
			end
		}))
	end
}



SMODS.Atlas {
	key = "discndeckatl",
	path = 'b_dis.png',
	px = 73,
	py = 97
}

SMODS.Back {
	name = "Discounted Deck",
	key = "discndeck",
	atlas = 'discndeckatl',
	pos = { x = 0, y = 0 },
	loc_txt = {
		name = "Discounted Deck",
		text = {
			"Start game with {C:money,T:v_liquidation}Liquidation{}",
			"{C:attention}Big Blinds{} give no reward money{}",
		},
	},
	config = { vouchers = { 'v_clearance_sale', 'v_liquidation' } },
	unlocked = true,
	discovered = true,
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.modifiers.no_blind_reward = G.GAME.modifiers.no_blind_reward or {}
				G.GAME.modifiers.no_blind_reward.Big = true
				return true
			end
		}))
	end
}

SMODS.Sound({
	vol = 1,
	pitch = 1,
	key = 'reflect',
	path = 'reflect.ogg'
})

SMODS.Sound({
	vol = 1,
	pitch = 1,
	key = 'reflect2',
	path = 'reflect2.ogg'
})

SMODS.Atlas {
	key = "rflctdeckatl",
	path = 'b_rfl.png',
	px = 71,
	py = 95
}

SMODS.Back {
	name = "Reflective Deck",
	key = "rflctdeck",
	atlas = 'rflctdeckatl',
	pos = { x = 0, y = 0 },
	loc_txt = {
		name = "Reflective Deck",
		text = {
			"On hand played,",
			"One card in deck is {C:attention}Converted{}",
			"To a random card {C:attention}played{}",
			"-1 {C:red}Discard{} every round"
		},
	},
	config = { discards = -1 },
	unlocked = true,
	discovered = true,
	apply = function(self)
		return true
	end,
	trigger_effect = function(self, args)
		print(args.context)
		if args.context == 'final_scoring_step' then
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.2,
				func = (function()
					---card in deck finding
					local randomCardInDeck = pseudorandom_element(G.playing_cards, pseudoseed(self.key))
					---card in hand finding and conversion
					local randomCardInHand = pseudorandom_element(G.play.cards, pseudoseed(self.key))

					if randomCardInHand ~= randomCardInDeck then
						copy_card(randomCardInHand, randomCardInDeck)
					end
					randomCardInHand:juice_up(1, 0.5)
					attention_text({
						scale = 1,
						text = 'Reflected!',
						hold = 2,
						align = 'cm',
						offset = { x = 0, y = -2.7 },
						major = G
							.play
					})
					if math.random(1,2) == 1 then
						play_sound('SVBA_reflect', 1, 0.75)
					else
						play_sound('SVBA_reflect2', 1, 0.75)
					end
					return true
				end)
			}))
		end
	end

}

SMODS.Atlas {
	key = "splashjokeratl",
	path = 'j_spl.png',
	px = 71,
	py = 95
}

--jokers
SMODS.Joker {
	--thank @oppositewolf770 on discord for fixing my broken code for this joker
	name = 'Soaker Joker',
	key = 'j_spl',
	atlas = 'splashjokeratl',
	rarity = 2,
	cost = 4,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {chips = 0, chip_gain = 4}},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
	  end,
	loc_txt = {
		name = 'Soaker Joker',
		text = {

		  "{C:chips}+#2#{} Chips for each played",
		  "card that is unscoring",
		  "{C:inactive}(Currently {}{C:chips}+#1#{}{C:inactive} Chips){}"
		}
	  },
	  calculate = function(self, card, context)
        if context.joker_main then
            if not context.blueprint then
                for _, current_card in pairs(context.full_hand) do
                    local valid_card = true
                    for _, scoring_card in pairs(context.scoring_hand) do
                        if current_card == scoring_card then
                            valid_card = false
                            break
                        end
                    end

                    if valid_card then
                        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                        card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Upgraded!', colour = G.C.CHIPS})
                    end
                end
            end

            return {
            chip_mod = card.ability.extra.chips,
            colour = G.C.CHIPS,
            message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }

            }
        end
    end

	--joker ideas:
	--Everything Must Go / Shopping Spree / Impulsive Spender: +2 cards in shop, but only if you have below $20 (Rare) (maybe a price tag as the artwork?)
	--Car Seat: 1/4 chance for a card in shop to be a booster pack instead (Rare)
	--Mortgage: x0.25 mult for every dollar in debt you are (Uncommon)

}