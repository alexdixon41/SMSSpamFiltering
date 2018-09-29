import re                  # regular expression library for detecting patterns in messages


def detect_features():
    # store spam/ham label for output
    if line[:4].find('spam') != -1:
        spam = 'TRUE'
        msg_length = len(line) - 5
    else:
        spam = 'FALSE'
        msg_length = len(line) - 4

    # count presence of numeric string of length 4 or more
    digit_strings = len(re.findall('[0-9]{4,}', line))

    # detect presence of URL
    if len(re.findall('www.|.com|.org|.net|http', line)) > 0:
        contains_url = 'TRUE'
    else:
        contains_url = 'FALSE'

    # detect presence of currency symbols
    currency_count = len(re.findall('[£$€]', line))
    if currency_count > 0:
        contains_currency = 'TRUE'
    else:
        contains_currency = 'FALSE'

    # count occurrences of keywords [win, won, free, txt, text, call, subscribe, prize, stop, end, reply, urgent]
    keywords = re.findall('win|won|free|txt|text|call|subscribe|prize|stop|reply|urgent|claim'
                          '|sms|pounds?|offers?|msg|club',
                          line.lower())
    keyword_count = len(keywords)

    return digit_strings, msg_length, contains_currency, keyword_count, spam


if __name__ == '__main__':
    print("Choose output format: ")
    print("1. .arff - WEKA file format")
    print("2. .csv - Comma Separated Values file format")
    output_format = input("->  ")
    if output_format == '2':
        output = open('output.csv', 'w')
        output.write('digit_strings,msg_length,contains_currency,keyword_count,spam\n')
    else:
        output = open('output.arff', 'w')
        output.write("@relation message\n\n")
        output.write("@attribute digit_strings real\n")
        output.write("@attribute msg_length real\n")
        output.write("@attribute contains_currency {TRUE, FALSE}\n")
        output.write("@attribute keyword_count real\n")
        output.write("@attribute spam {TRUE, FALSE}\n\n")
        output.write("@data\n")

    f = open('SMSSpamCollection', 'r')
    for line in f:
        line = line.lower()                       # make text case-insensitive for feature detection
        features = detect_features()
        for i in range(len(features) - 1):
            output.write(str(features[i]) + ',')
        output.write(str(features[len(features) - 1]) + "\n")
