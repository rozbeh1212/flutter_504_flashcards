# # import requests
# # from bs4 import BeautifulSoup
# # import json

# # # specify the URL of the page to be scraped
# # url = 'https://www.vocabulary.com/lists/145774'

# # # send a GET request to the specified URL
# # response = requests.get(url)

# # # parse the HTML content of the page using Beautiful Soup
# # soup = BeautifulSoup(response.content, 'html.parser')

# # # find all the items with class "entry learnable"
# # entries = soup.find_all(class_='entry learnable')

# # # create an empty list to store the data
# # data = []

# # # iterate through each entry and extract the word and definition
# # for entry in entries:
# #     word = entry.find(class_='word').text.strip()
# #     definition = entry.find(class_='definition').text.strip()

# #     # create a dictionary for the word and definition
# #     item = {'word': word, 'definition': definition}

# #     # add the dictionary to the list
# #     data.append(item)

# # # save the data as a JSON file
# # with open('vocabulary.json', 'w') as outfile:
# #     json.dump(data, outfile)
# import requests
# from bs4 import BeautifulSoup
# import json

# # specify the URL of the page to be scraped
# url = 'https://www.vocabulary.com/lists/145774'

# # send a GET request to the specified URL
# response = requests.get(url)

# # parse the HTML content of the page using Beautiful Soup
# soup = BeautifulSoup(response.content, 'html.parser')

# # find all the items with class "entry learnable"
# entries = soup.find_all(class_='entry learnable')

# # create an empty list to store the data
# data = []

# # iterate through each entry and extract the relevant information
# for entry in entries:
#     # extract the word and definition
#     word = entry.find(class_='word').text.strip()
#     definition = entry.find(class_='definition').text.strip()
    
#     # extract the phonetics
#     try:
#         phonetics = entry.find('span', attrs={'class': 'phonetics'}).text.strip()
#     except AttributeError:
#         phonetics = ''
    
#     # extract the example sentences
#     examples = []
#     for ex in entry.find_all('div', attrs={'class': 'example'}):
#         examples.append(ex.text.strip())
    
#     # extract the part of speech and meaning
#     pos_meaning = []
#     for posm in entry.find_all('div', attrs={'class': 'sense'}):
#         pos = posm.find('h3').text.strip()
#         meaning = posm.find('div', attrs={'class': 'definition'}).text.strip()
#         pos_meaning.append({'part_of_speech': pos, 'meaning': meaning})
    
#     # create a dictionary for the word and all its data
#     item = {'word': word, 'definition': definition, 'phonetics': phonetics,
#             'examples': examples, 'pos_meaning': pos_meaning}
    
#     # add the dictionary to the list
#     data.append(item)

# # save the data as a JSON file
# with open('vocabulary.json', 'w') as outfile:
#     json.dump(data, outfile)
import json
from googletrans import Translator

# # create a translator object
# translator = Translator(service_urls=['translate.google.com'])

# # read the existing data from the JSON file
# with open('vocabulary.json', 'r') as infile:
#     data = json.load(infile)

# # iterate through each item in the data and add Persian translations for the definitions
# for item in data:
#     # retrieve the definitions for the word
#     definitions = item['definition'].split(';')

#     # translate each definition to Persian
#     persian_definitions = []
#     for definition in definitions:
#         try:
#             translation = translator.translate(definition, dest='fa').text
#         except:
#             translation = None

#         persian_definitions.append(translation)

#     # add the translated definitions to the existing data
#     item['persian_definitions'] = persian_definitions

# # save the updated data as a JSON file
# with open('vocabulary_updated.json', 'w') as outfile:
#     json.dump(data, outfile)
import json
from googletrans import Translator
from nltk.corpus import wordnet as wn

# create a translator object
translator = Translator(service_urls=['translate.google.com'])

# read the existing data from the JSON file
with open('vocabulary.json', 'r') as infile:
    data = json.load(infile)

# iterate through each item in the data and add Persian translations, phonetics, examples and part of speech in English for the definitions
for item in data:
    # retrieve the word
    word = item['word']

    # retrieve the definitions for the word
    definitions = item['definition'].split(';')

    # translate each definition to Persian
    persian_definitions = []
    phonetics = []
    examples = []
    pos_english = []

    for definition in definitions:
        try:
            # translate definition to Persian
            persian_def = translator.translate(definition, dest='fa').text
            persian_definitions.append(persian_def)

            # get the phonetics of the word
            synset = wn.synsets(word)
            if synset:
                phonetic = synset[0].lemma_names('eng')[0]
                phonetics.append(phonetic)

            # get the examples of the word
            examples_list = []
            for example in synset[0].examples():
                example = example.replace(word, '<b>' + word + '</b>')
                example_fa = translator.translate(example, dest='fa').text
                examples_list.append(example_fa)

            examples.append(examples_list)

            # get the part of speech in English
            pos = synset[0].pos()
            if pos == 'n':
                pos_english.append('noun')
            elif pos == 'v':
                pos_english.append('verb')
            elif pos == 'a':
                pos_english.append('adjective')
            elif pos == 'r':
                pos_english.append('adverb')
            else:
                pos_english.append('')

        except:
            persian_definitions.append(None)
            phonetics.append('')
            examples.append([])
            pos_english.append('')

    # add the translated definitions, phonetics, examples and part of speech to the existing data
    item['persian_definitions'] = persian_definitions
    item['phonetics'] = phonetics
    item['examples'] = examples
    item['pos_english'] = pos_english

# save the updated data as a JSON file
with open('vocabulary_updated.json', 'w') as outfile:
    json.dump(data, outfile)
