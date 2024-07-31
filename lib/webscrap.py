import requests
from bs4 import BeautifulSoup
import re
import json

def fetch_content(url):
    response = requests.get(url)
    return BeautifulSoup(response.content, 'html.parser')

def extract_readings(soup):
    main_content = soup.find('div', class_='main-content h-full')
    
    if main_content:
        article = main_content.find('article', id='mainContent')
        
        if article:
            content_div = article.find('div', class_='blogview_content useless_p_margin editor_ke')
            
            if content_div:
                content = content_div.get_text(separator='\n', strip=True)
                return content
    
    return "교독문 내용을 찾을 수 없습니다."

def split_readings(content):
    readings = {}
    current_reading = ""
    current_number = 0

    pattern = r'\d+\.'
    
    lines = content.split('\n')
    for line in lines:
        if re.match(pattern, line):
            if current_reading and current_number > 0:  # 변경된 부분
                readings[f"tile_{current_number}"] = current_reading.strip()
            current_number = int(line.split('.')[0])
            current_reading = line + '\n'
        else:
            current_reading += line + '\n'
    
    if current_reading and current_number > 0:  # 변경된 부분
        readings[f"tile_{current_number}"] = current_reading.strip()
    
    return readings

def save_to_json(readings, filename):
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(readings, f, ensure_ascii=False, indent=2)

def main():
    url = "https://hangil91.tistory.com/m/296"  # 실제 URL로 교체해야 합니다
    soup = fetch_content(url)
    content = extract_readings(soup)
    readings = split_readings(content)
    
    save_to_json(readings, 'readings.json')
    print("교독문이 readings.json 파일로 저장되었습니다.")

if __name__ == "__main__":
    main()