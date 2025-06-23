from colorama import Fore, Style
from datetime import datetime
import time
import re

currentdate = datetime.today().strftime('%Y%m%d')

logFilePath = "example_log.adi"



def parse_line(line):
    pattern = r"<(\w+):\d+>([^<]+)"
    matches = re.findall(pattern, line)
    return {key.upper(): value for key, value in matches}

def watch(fn):
    fp = open(fn, 'r', encoding="utf-8")
    isEOHReached = 0
    while True:
        new = fp.readline()

        # don't return anything until the End Of Header is reached
        if isEOHReached == 0:
            if new.upper().startswith("<EOH>"):
                isEOHReached = 1

        else:
            # once all lines are read this just returns ''
            # until the file changes and a new line appears
            if new:
                #check that the line is not empty
                if new.strip() != "":
                    yield new
            else:
                time.sleep(1)

fn = logFilePath
words = ['word']
isHeaderDisplayed = False
HeaderFields = {'CALL': 10, 'GRIDSQUARE': 10, 'MODE': 6, 'RST_SENT': 8, 'RST_RCVD': 8, 'QSO_DATE': 9, 'TIME_ON': 7, 'TIME_OFF': 8, 'BAND': 4, 'FREQ': 12, 'MY_GRIDSQUARE': 13, 'TX_PWR': 6}
#, 'COMMENT': 25}
separator = 7+ 10+ 4+ 8+ 8+ 9+ 7+ 8+ 4+ 9


try:
    for line in watch(fn):
        parsed_data = parse_line(line)
        if isHeaderDisplayed == False:

            parsed_line = parsed_data.keys()

            column_widths = HeaderFields
         
            header_line = " | ".join(f"{header:<{column_widths[header]}}" for header in HeaderFields)
            separator_line = "-".join("-" * separator)

            #print fancy header with separator line
            print(header_line)
            print(separator_line)
            isHeaderDisplayed=True

        #set the color to bright green so it's easy to read
        row_color = Fore.GREEN + Style.BRIGHT
        #only display QSOs made today
        if(parsed_data.get('QSO_DATE', '').startswith(currentdate)):
            print(row_color + " | ".join(f"{parsed_data.get(vals, ''):<{column_widths[vals]}}" for vals in HeaderFields))

except KeyboardInterrupt:
    exit
