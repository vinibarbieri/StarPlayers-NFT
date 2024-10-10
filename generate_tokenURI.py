import json
import os

# Função para gerar metadados JSON
def create_metadata(name, description, image_url, position, jersey_number, age, club, overall_skill, rarity, num_units):
    for i in range(1, num_units + 1):
        # Nome exclusivo para cada unidade
        metadata = {
            "name": f"{name} - {rarity} #{i}",
            "description": description,
            "image": image_url,
            "attributes": [
                {
                    "trait_type": "Position",
                    "value": position
                },
                {
                    "trait_type": "Jersey Number",
                    "value": jersey_number
                },
                {
                    "trait_type": "Age",
                    "value": age
                },
                {
                    "trait_type": "Club",
                    "value": club
                },
                {
                    "trait_type": "Overall Skill",
                    "value": overall_skill
                },
                {
                    "trait_type": "Rarity",
                    "value": rarity
                }
            ]
        }

        # Criação da pasta baseada no nome do jogador
        player_folder = name.replace(" ", "_").lower()
        os.makedirs(player_folder, exist_ok=True)

        # Salvando cada arquivo com seu número
        filename = f"{player_folder}/{i}.json"
        with open(filename, 'w') as f:
            json.dump(metadata, f, indent=4)
        print(f"Arquivo {filename} criado.")

# Informações dos jogadores
players = [
    {
        "name": "Luca Barbosa",
        "description": "Exclusive NFT of forward João Silva in action for London FC.",
        "image_url": "https://green-total-felidae-639.mypinata.cloud/ipfs/QmRnLzo8Qge62k5Cr9a7p6dZTZt3HtbzuXq8nHLu8wmec2",
        "position": "Forward",
        "jersey_number": 27,
        "age": 25,
        "club": "London FC",
        "overall_skill": 90,
        "rarity": "Legend",
        "num_units": 10
    },
    {
        "name": "Carlos Mendes",
        "description": "Exclusive NFT of midfielder Carlos Mendes, known for his exceptional vision and passing.",
        "image_url": "https://green-total-felidae-639.mypinata.cloud/ipfs/QmbovdUBWoutjUb7oXof7QrQDrW6XBykWwnFkYcWSvZ6BA",
        "position": "Midfielder",
        "jersey_number": 17,
        "age": 28,
        "club": "Paris City FC",
        "overall_skill": 87,
        "rarity": "Idol",
        "num_units": 30
    },
    {
        "name": "Roberto Alvarez",
        "description": "Exclusive NFT of defender Roberto Alvarez, a stalwart in the backline for Milano FC.",
        "image_url": "https://green-total-felidae-639.mypinata.cloud/ipfs/QmP86QowVR98iMBWTsYhbjrR1Xa3yj5MzHtnyKk1sBG75Z",
        "position": "Defender",
        "jersey_number": 4,
        "age": 30,
        "club": "Milano FC",
        "overall_skill": 84,
        "rarity": "Crack",
        "num_units": 50
    }
]

# Gerando arquivos JSON para cada jogador
for player in players:
    create_metadata(
        player["name"],
        player["description"],
        player["image_url"],
        player["position"],
        player["jersey_number"],
        player["age"],
        player["club"],
        player["overall_skill"],
        player["rarity"],
        player["num_units"]
    )
