import urllib.request
import re
url="https://news.ycombinator.com/"
response = urllib.request.urlopen(url)
html=response.read().decode('utf-8')
print(html)
test_str = "<a href=\"https://www.w3schools.com\">Visit W3Schools</a> <a href=\"https://www.w4schools.com\">Visit W4Schools</a>"
print(re.findall(r'(\w+://\S+)"',html))
print(len(re.findall(r'(\w+://\S+)"',html)))

