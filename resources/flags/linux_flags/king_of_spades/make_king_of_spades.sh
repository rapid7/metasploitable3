#!/bin/bash

zip king_of_spades.zip king_of_spades.png
cat fake.png king_of_spades.zip > card.png
rm king_of_spades.zip
echo "Done"
