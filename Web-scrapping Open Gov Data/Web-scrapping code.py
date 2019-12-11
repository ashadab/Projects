#!/usr/bin/python -tt

import os
import time

from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.firefox.firefox_binary import FirefoxBinary
from selenium.webdriver.common.keys import Keys

savepath= 'E:\Shadab\AIIMS Project Related\Indian Health Data\Annual Health Survey'

profile = webdriver.FirefoxProfile()
profile.set_preference('browser.download.folderList', 2) # custom location
profile.set_preference('browser.download.manager.showWhenStarting', False)
profile.set_preference('browser.download.dir', savepath) 
profile.set_preference('browser.helperApps.neverAsk.saveToDisk', 'application/octet-stream')

browser = webdriver.Firefox(profile)
url= "https://data.gov.in/catalog/annual-health-survey-combined-household-houselist-information"
browser.get(url)
time.sleep(2)
print(browser.title)  #title of the page is: Rural Health Statistics - 2015 | Open Government Data (OGD) Platform India



#downloading first page files

window_before=browser.window_handles[0]
#print window_before

list_csv=[]
list_csv=browser.find_elements_by_link_text('csv')



for i in range(len(list_csv)):              #0:(len(list_csv)-1):
       
    #finding name of 1st element
    element_list=browser.find_elements_by_class_name("title-content")
    time.sleep(5)
    element_singleton_initial=element_list[i].text     #element.get_attribute('value')..... value is used for INPUT elements values
    
	#for removing special characters from file name of title  
    element_singleton_long="".join(i for i in element_singleton_initial if i not in "\/:*?<>|")
    element_singleton= (element_singleton_long[:111]+'..') if len(element_singleton_long)>110 else element_singleton_long
    loop_number =str(i+1)
    element_file_name= element_singleton + " Page 1" + "_" + loop_number   
    print(element_file_name)

    #clicking 1st element
    list_csv[i].click()
    time.sleep(300)	
    
	#going to download window and closing it
    window_after=browser.window_handles[1]
    browser.switch_to_window(window_after)
    #print window_after
    browser.close()
	
	#switching back to main/original window
    time.sleep(5)
    browser.switch_to_window(window_before)
	
	#renaming file which was saved recently
    docName= element_file_name
    os.chdir(savepath)
    files = filter(os.path.isfile, os.listdir(savepath))
    files = [os.path.join(savepath, f) for f in files] # add path to each file
    files.sort(key=lambda x: os.path.getmtime(x))
    time.sleep(5)
    newest_file = files[-1]
    os.rename(newest_file, docName+".csv")
   

#output is not coming in an ordered list format



#moving to next page


page_download=48   # enter the number pages you want to download

page_input=page_download +1


for j in range(2, page_input):	
    
    j_1=str(j)
    next_page=browser.find_element_by_link_text(j_1)
    next_page.click()
    time.sleep(5)
    
    window_before=browser.window_handles[0] 	
    list_csv=[]
    list_csv=browser.find_elements_by_link_text('csv')
    


    for i in range(len(list_csv)):

        #finding name of 1st element
        element_list=browser.find_elements_by_class_name("title-content")
        time.sleep(5)
        element_singleton_initial=element_list[i].text     #element.get_attribute('value')..... value is used for INPUT elements values
    
	    #for removing special characters from file name of title  
        element_singleton_long="".join(i for i in element_singleton_initial if i not in "\/:*?<>|")
        element_singleton= (element_singleton_long[:111]+'..') if len(element_singleton_long)>110 else element_singleton_long
        loop_number =str(i+1)
        element_file_name= element_singleton + " Page " + j_1 + "_" + loop_number   
        print(element_file_name)

        #clicking 1st element
        list_csv[i].click()
        time.sleep(300)	
    
	    #going to download window and closing it
        window_after=browser.window_handles[1]
        browser.switch_to_window(window_after)
        #print window_after
        browser.close()
	
	    #switching back to main/original window
        time.sleep(5)
        browser.switch_to_window(window_before)
	
	    #renaming file which was saved recently
        docName= element_file_name
        os.chdir(savepath)
        files = filter(os.path.isfile, os.listdir(savepath))
        files = [os.path.join(savepath, f) for f in files] # add path to each file
        files.sort(key=lambda x: os.path.getmtime(x))
        time.sleep(5)
        newest_file = files[-1]
        os.rename(newest_file, docName+".csv")
		
  
browser.quit()