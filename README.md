# Honeypot Project
Team members: Caitlynn Li, Katherine Wang, Maria Mao, Joshua Liu
## Research Question: Is there a correlation between bot types and their country of origin, time of attack, and duration of attack?
- Three containers with identical framework, each assigned a different ip address
- Within each container a file structure was created in which PII was hidden at the deepest level to track attacker's interest and determination in accessing the PII
- Utilized chi squared test to determine if there was a significant relation between bot type and their, country of origin, time of attack, and duration of attack
## Results
After comparing the types of bot attacks against the regions the attacks came from, the duration of the attacks, and number of commands run by the attackers, the results suggested that there was a general association for all our data. From the results, there is a correlation between the attack type of the bots (which were those that attempted to get backend information, hardware information, or adding or removing from the honeypot) and variables tested against it. These results support the idea that it is possible to identify a bot type using its location/region, duration of attack, and number of commands run, as each type of bot generally fit into the categories similarly. Implications for our results include understanding the type of bot attack upon a second entrance into a system, and being able to manipulate or predict its actions as needed or being able to prevent specific bot types (categorized through our analysis) from doing harm to a system.
In the future, possible work that could be done would be further breaking down the bots into more specific types, or testing our hypothesis against other variables, and testing to see if there were further correlations. It is possible that in more specific types, there is a higher correlation between the type and the factors tested against it. There may be more specific ways to break down the types we labeled our bots with, and we may see more clear associations between the types of the bot attacks and the variables. It may also be possible to see that other variables will help reveal the type of a bot and form even clearer type differences between the bots. A research question that could be posed after the conclusion of this study would be whether or not bot attacks and actions could be accurately anticipated, predicted, and handled as necessary using our research.
Overall, through the analysis of the data collected by our honeypots, our hypothesis was supported in that there were general correlations between types of bot attacks and the variables region, duration and number of commands of the attacks. 






