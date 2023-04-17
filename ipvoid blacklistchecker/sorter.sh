cat output.txt | tr , '\n' > filter.txt
cat filter.txt | grep "risk_score\|data"
