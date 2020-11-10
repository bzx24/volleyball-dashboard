#create attack efficiency metric
attacks <- data_6v6 %>%
  filter(skill == "Attack") %>%
  group_by(player_name) %>%
  mutate(attack_kill = sum(evaluation == "Winning attack"),
         attack_error = sum(evaluation %in% c("Blocked", "Error"))) %>%
  group_by(player_name,
           attack_kill,
           attack_error) %>%
  summarise(attack_att = n()) %>%
  mutate(attack_eff = (attack_kill - attack_error) / attack_att)