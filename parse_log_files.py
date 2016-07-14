import os, sys
import multiprocessing, time
import argparse as agp
#from termcolor import colored

NUMBER_OF_PROCESSES = multiprocessing.cpu_count()

'''
Code added from the following link:
http://stackoverflow.com/questions/3893885/cheap-way-to-search-a-large-text-file-for-a-string
'''
parser = agp.ArgumentParser(
        description='MultiProcessor Text File Parsing\nAuthor: Debjit Pal\nEmail: dpal2@illinois.edu', formatter_class=agp.RawTextHelpFormatter
        )
parser.add_argument("-p", "--path", help="Path to Test Run Directory", required=True)
parser.add_argument("-g", "--group", help="Test Group name (fc1_all_T2, fc1_mini_T2, fc1_paper)", required=True)
parser.add_argument("-a", "--all", action='store_true', help="Print all ocurences of the monitor occurence. Default is to print the first occurence only")
parser.add_argument("-l", "--loc", help="Location to dump message log file. Mandatory with -a parameter")
args = parser.parse_args()


path = args.path
group_name = args.group
dump_location=''
allo = False

# Checking all dump arguments
if args.all and not args.loc:
    parser.error('-l / --loc is mandatory with -a / -all')
elif args.all and args.loc:
    allo = args.all
    dump_location = args.loc

monitor_name = ['dmu_to_siu_mon', 'niu_to_siu_mon', 'siu_to_l2_mon', 'siu_to_ncu_mon', 'l2_proto_mon', 'ncu_proto_mon', 'l2_to_siu_mon', 'siu_to_dmu_mon', 'siu_to_niu_mon']


def FindTextAtAllOccurence( host, file_name, text):
    file_size = os.stat(file_name).st_size
    m1 = open(file_name, "r")

    chunk = (file_size / NUMBER_OF_PROCESSES ) + 1
    
    # A major change from Single Occurence subroutine

    lines = []
    line_found_at = []

    seekStart = chunk * (host)
    seekEnd = chunk * (host + 1)

    if seekEnd > file_size:
        seekEnd = file_size

    if host > 0:
        m1.seek( seekStart )
        m1.readline()

    line = m1.readline()

    while len(line) > 0:
        #lines = lines + 1
        if text in line:
            line_found_at.append(lines)
            lines.append(line)
        if m1.tell() > seekEnd or len(line) == 0:
            break
        line = m1. readline()

    m1.close()
    return host, lines, line_found_at

def FindTextAtSingleOccurence( host, file_name, text):
    file_size = os.stat(file_name ).st_size 
    m1 = open(file_name, "r")

    #work out file size to divide up to farm out line counting

    chunk = (file_size / NUMBER_OF_PROCESSES ) + 1
    lines = 0
    line_found_at = -1

    seekStart = chunk * (host)
    seekEnd = chunk * (host+1)
    if seekEnd > file_size:
        seekEnd = file_size

    if host > 0:
        m1.seek( seekStart )
        m1.readline()

    line = m1.readline()

    while len(line) > 0:
        lines += 1
        if text in line:
            #found the line
            line_found_at = lines
            break
        if m1.tell() > seekEnd or len(line) == 0:
            break
        line = m1.readline()
    m1.close()
    return host,lines,line_found_at

# Function run by worker processes
def worker(input, output):
    if not allo:
        for host,file_name,text in iter(input.get, 'STOP'):
            output.put(FindTextAtSingleOccurence( host,file_name,text ))
    else:
        for host,file_name,text in iter(input.get, 'STOP'):
            output.put(FindTextAtAllOccurence(host, file_name, text ))

def main(diag_file_handle,file_name,text):
    t_start = time.time()
    # Create queues
    task_queue = multiprocessing.Queue()
    done_queue = multiprocessing.Queue()
    #submit file to open and text to find
    #print 'Starting', NUMBER_OF_PROCESSES, 'searching workers'
    for h in range( NUMBER_OF_PROCESSES ):
        t = (h,file_name,text)
        task_queue.put(t)

    #Start worker processes
    for _i in range(NUMBER_OF_PROCESSES):
        multiprocessing.Process(target=worker, args=(task_queue, done_queue)).start()

    # Get and print results
    # Two different type of printing will happen here
    # Type 1: If the data is coming from FindTextAtSingleOccurence. Then the existing print remians
    # Type 2: If the data is coming from FindTextAtAllOccurence. Then the new print system has to work

    if not allo:
        results = {}
        for _i in range(NUMBER_OF_PROCESSES):
            host,lines,line_found = done_queue.get()
            results[host] = (lines,line_found)

        # Tell child processes to stop
        for _i in range(NUMBER_OF_PROCESSES):
            task_queue.put('STOP')
        #   print "Stopping Process #%s" % i

        total_lines = 0
        for h in range(NUMBER_OF_PROCESSES):
            if results[h][1] > -1:
                print text, 'Found at', total_lines + results[h][1], 'in', time.time() - t_start, 'seconds'
                #break
                return 1
            total_lines += results[h][0]
    else:
        results = {}
        for _i in range(NUMBER_OF_PROCESSES):
            host,lines,line_found = done_queue.get()
            results[host] = (lines, line_found)

        # Tell child processes to stop
        for _i in range(NUMBER_OF_PROCESSES):
            task_queue.put('STOP')

        for h in range(NUMBER_OF_PROCESSES):
            if len(results[h][0]) > 0:
                diag_log_file.write("".join(results[h][0]))
                return 1
    return 0

if __name__ == "__main__":
    subdirectories = os.listdir(path)
    # Dictionary to store test name and the monitors that are sensitized in its run
    diag_name = {}
    for subdir in subdirectories:
        if os.path.isfile(subdir):
            continue
        if group_name in subdir:
            diag_name_ = subdir.split(':')
            print '#' * 20
            print "Working on " + diag_name_[0]
            fileName = subdir + '/sims.log'
            logFileName = dump_location + '/' + diag_name_[0] + "_messages.log"
            diag_log_file = open(logFileName, 'w')
            for monitor_name_ in monitor_name:
                if(main( diag_file_handle = diag_log_file, file_name = fileName, text = monitor_name_ )):
                    if diag_name_[0] in diag_name.keys():
                        diag_name[diag_name_[0]].append(monitor_name_)
                    else:
                        diag_name[diag_name_[0]] = [monitor_name_]
            diag_log_file.close()
            print '#' * 20 + "\n"

    total_num_diags = 0
    if diag_name:
        for key_ in diag_name.keys():
            if len(diag_name[key_]) >= 2:
                print "Diag " + key_ + " triggered following monitors: " + ', '.join(diag_name[key_])
                total_num_diags += 1

    print "Total Valuable Diags Found: " + str(total_num_diags)
