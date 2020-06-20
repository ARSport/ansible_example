#!/bin/bash
#Creating an orchestator for Ansible
#Run like:
#./orchestrator.sh yum_update a
#Where yum_update is the action (Valid yum_update, reboot and check_kernel)

#Validate the action
check_the_action (){
  case  $1  in
    yum_update|reboot|check_kernel)
        action=$1 ;;
    *)
    echo "Please provide a valid action and run like this: ./orchestrator.sh action side"
    echo "Where action could be yum_update, reboot and check_kernel"
    exit 2 ;;
  esac
}

#Validate the side
#Be aware the it says $1 but is checking and assigning $2 per below in the script call to the function check_the_side
check_the_side (){
  case  $1  in
    a|b)
        side=$1 ;;
    *)
    echo "Please provide a valid side and run like this: ./orchestrator.sh action side"
    echo "Where side could be a or b and action could be yum_update, reboot and check_kernel"
    exit 2 ;;
  esac
}

orchestrator (){
directory="../../hosts/"
echo $action
for hostlistitem in $(ls $directory)
do
    sh -c "ansible-playbook -i $directory/$hostlistitem --extra-vars -b $action.yml" &
#Sometimes you need to add a pause to avoid collitions somewhere in Ansible management.
    sleep 120
  fi
done
}

check_the_action $1
orchestrator $action
