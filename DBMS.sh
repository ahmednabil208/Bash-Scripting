#!/bin/bash

display_List()
{
        echo 
        echo "1) Create Database        2) List Databases "
        echo "3) Connect To Databases   4) Drop Database      5)Exit "
}

display_List2()
{
        echo
        echo "1)Create Table        2)List Tables           3)List Table contents   " 
        echo "4)Drop Table          5)Insert into Table     6)Select From Table     " 
        echo "7)Delete From Table   8)Modify Data           9)Back"
}


echo
echo "           Database Management System "
echo
PS3="Enter your choice: "
select c in "Create Database" "List Database" "Connect To Database" "Drop Database" "Exit"
do
        case $REPLY in
                1)
				        clear
						echo "         Create Database"
						echo "         ----------------"						
                        read -p "Database Name: " DbName
                        if [ -n "$(find . -name "$DbName" -type d)" ]
                        then                              
                                echo "$DbName already exists"
								echo "****************************"
                        else
                                mkdir "$DbName"           
                                echo "$DbName created"
								echo "****************************"
                        fi
                        display_List
                        ;;
                2)
						clear
						echo "         List Databases"
						echo "         ----------------"										
                        echo "List of Existing Databases:"
						 echo "****************************"
                        ls -p | grep /
                        display_List
                        ;;
                3)
						clear
						echo "         Connect TO Database"
						echo "         ----------------"										
                        read -p "Database Name: " DbName
                        if [ -n "$(find . -name "$DbName" -type d)"  ]
                        then
                                cd $DbName
								echo "           Welcome To $DbName Database"    
                                select c in "Create Table" "List Tables" "List Table contents" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Modify Data" "Back"
                                do
                                          case $REPLY in
										          
                                                  1) 
												          clear
														  echo "         Create Table"
														  echo "         ------------"
														  read -p "Table Name: " TableName
                                                          if [ -n "$(find . -name "$TableName" -type f )" ]
                                                          then
                                                                  echo "****************************"
                                                                  echo "$TableName already exists"
                                                          else
                                                                  touch "$TableName"
                                                                  echo "****************************"
                                                                  echo "$TableName created"
																  echo "****************************"
                                                                  echo "Note: Press Enter To Stop"
                                                                  read -p "Primary Key Field Name: " PK_Field
                                                                  touch .pk_field_name
                                                                  echo "$PK_Field" >> .pk_field_name
                                                                  store_PK="$PK_Field"
                                                                  echo -n "$PK_Field:" >> "$TableName"
                                                                  fn=2 #field number
                                                                  while true
                                                                  do
                                                                         read -p "Field$fn Name: " field
                                                                         if [ -z "$field"  ]
                                                                         then
                                                                                 n=2
                                                                                 echo >> "$TableName"
                                                                                 echo "----------------------------------" >> "$TableName"
                                                                                 echo Fields Inserted
                                                                                 break
                                                                         else
                                                                                 echo -n "$field:" >>  "$TableName"
                                                                                         let fn="$fn"+1
                                                                         fi

                                                                     done
                                                           fi
                                                           display_List2
                                                           ;;
                                                  2)
														  clear
														  echo "Avialable Tables: "	
														  echo "------------------"
														  ls -p | grep -v /
														  display_List2
                                                          #ls -p: Lists all files and directories in the current directory and appends a / to the end of directory names.
														  #grep -v /: Filters out any line that ends with /, effectively removing directories from the list, leaving only files.
                                                          ;;
                                                  3)
														  
                                                          read -p "Table Name: " TableName
														  clear
                                                          if [ -n "$(find . -name "$TableName" -type f )"  ]
                                                          then
																  echo "          $TableName Table contents"
                                                                  echo "          ---------------------------"
                                                                  cat "$TableName"
                                                                  echo
                                                          else
                                                                  echo "$TableName not found"
                                                          fi
                                                          display_List2
                                                          ;;
                                                4)
														  clear
                                                          read -p "Table Name: " TableName
                                                          if [ -n "$(find . -name "$TableName" -type f )"  ]
                                                          then
                                                                  rm -f "$TableName"                                                       
                                                                  echo "$TableName deleted"
																  echo "****************************"
                                                          else
                                                                   echo "$TableName not found"
																   echo "****************************"
                                                          fi
                                                          display_List2
                                                          ;;

                                                  5)
												          clear
														  echo "       Insert Data Into Table"
														  echo "       -----------------------"
                                                          read -p "Table Name: " TableName
                                                          if [ -n "$(find . -name "$TableName" -type f)"    ]
                                                          then

                                                                  N=$(awk -F: '{if(NR==1){ print NF}}' "$TableName")
                                                                  ((N--))
                                                                  fn=1
                                                                  while [ "$fn" -le "$N"  ]
                                                                  do
                                                                          field_name=$(awk -F: -v col="$fn" '{if(NR==1) {print $col}}' "$TableName")
                                                                          read -p "$field_name:" field
																		  #check if primary key exists or not
																		  if [ -n "$(awk -F: -v field2="$field"  '{if($1 == field2) {print $0}}' $TableName)" ]
																		            
																		  then
																				echo "$field is already exist"
																				break																		  
																		  fi
                                                                          if [ -z "$field"  ]    #pressed Enter   																			                  
                                                                          then
                                                                                 n=2
                                                                                 echo  >> "$TableName"
                                                                                 echo "****************************"
                                                                                 echo Data Inserted
																				 echo "****************************"
                                                                                 break
                                                                         else
                                                                                 echo -n "$field:" >>  "$TableName"
                                                                                 let fn="$fn"+1
                                                                         fi
                                                                done
                                                                echo   >> "$TableName"

                                                          else
                                                                  echo "$TableName not found"
                                                          fi
                                                          display_List2
                                                          ;;

                                                  6)
												          clear
														  echo "      Select From Table"
														  echo "      ------------------"
                                                          read -p "Table Name: " TableName
                                                          if [ -f "$TableName"  ]
                                                          then

                                                                read -p "$TableName `cat .pk_field_name`:" ip_pk
                                                                if [  -z "$(grep "$ip_pk" "$TableName")"  ]
                                                                then                                        
                                                                        echo Not Found
																		echo "******************"
                                                                else

                                                                       grep "$ip_pk" "$TableName"
							                                           echo "******************"
                                                                fi

                                                          else
                                                                  echo "$TableName not found"
                                                          fi
                                                          display_List2
                                                          ;;

                                                  7)
												          clear
														  echo "        Delete Data From Table"
														  echo "        -----------------------"
                                                          read -p "Table Name: " TableName
                                                          if [ -n "$(find . -name "$TableName" -type f )"  ]
                                                          then
                                                                  read -p "Person `cat .pk_field_name`: " id
                                                                  if [ -n "$(grep "$id" "$TableName")" ] #search id in the file
                                                                  then
                                                                          sed -i "/$id/d" "$TableName"
                                                                          echo "***********************"
                                                                          echo "Line with `cat .pk_field_name`="$id" has been deleted"
                                                                  else                                                                         
                                                                          echo "ID not found"
																		  echo "****************************"
                                                                  fi

                                                          else
                                                                  echo "$TableName not found"
																  echo "**********************"

                                                          fi
                                                          display_List2
                                                          ;;


                                                  8)
												           clear
														   
                                                          echo "             Modify Data "
														  echo "             ------------"
                                                          read -p "Table Name: " TableName
                                                          if [ -f "$TableName" ]
                                                          then
                                                                  read -p "$TableName  `cat .pk_field_name`: " id
                                                                  read -p "old data: " old
                                                                  read -p "new data: " new
                                                                  #sed  -i "/^$i/),s/$old/$new/" $TableName
																  sed  -i "/^$id/{s/$old/$new/}" $TableName
																  #sed  -i "/$id/d" "$TableName"
                                                                  echo Data updated successfully
																  echo "**************************"
                                                          else
                                                                  echo "$TableName not found"
																  echo "*********************"
                                                          fi
														  display_List2
                                                          ;;
                                                  9)
												          clear
                                                          cd ..
                                                          break 1
                                                          ;;

                                                  *)
                                                         
                                                          echo "Inavalid Option, Please Try again "
														  echo "**********************************"
                                                          display_List2
                                                          ;;

                                                  esac
                         done
                         else
                                echo "****************************"
                                echo "$DbName not found"
                         fi
                         display_List
                         ;;
                4)   
				        clear
						echo "         Connect To Database" 
						echo "         -------------------"
                        read -p "Database Name: " DbName
                        if [ -n "$(find . -name "$DbName" -type d)" ]
                        then
                                rm -rf "$DbName"                                
                                echo "$DbName Deleted"
								echo "****************************"
                        else                               
                                echo "$DbName not found"
								echo "****************************"
                        fi
                        display_List
                        ;;
                5)
				        clear                       
                        echo "Exiting"
						echo "****************************"
                        break
                        display_List
                        ;;
                *)
						 clear							 
						 echo "Invalid option. Please try again."
						 echo "**********************************"
						 ;;
        esac
done

                                                                                                                                         