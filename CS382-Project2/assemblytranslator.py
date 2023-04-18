
## PYTHON FILE FOR DECODING OUR ASSEMBLY

## READ FROM FILE
print("Name of Instruction file: ")
instruction_file = input()
with open(instruction_file, 'r') as f:
    line = f.readline()
    hexArray = []
    num = 0
    while (line != 'DON' and line != ''):
        if (line[0:3] == 'LOD'):
            num = (int(line[4:6]))<<2
            num += int(line[8])
            if len(hex(num)[2:4]) == 1:
                newhex = '0'+hex(num)[2:4]
                hexArray.append(newhex)
            else:
                hexArray.append(hex(num)[2:4])
            #print(hexArray)
        if (line[0:3] == 'ADD'):
            num = 64
            num += int(line[5])<<4
            num += int(line[8])<<2
            num += int(line[11])
            hexArray.append(hex(num)[2:4])
            #print(hexArray)
        if (line[0:3] == 'SUB'):
            num = 128
            num += int(line[5])<<4
            num += int(line[8])<<2
            num += int(line[11])
            hexArray.append(hex(num)[2:4])
            #print(hexArray)

        line = f.readline()
    #print(hexArray)
    f.close()

## WRITE TO FILE
print("Intended name of Instruction Memory file: ")
instructionmemory_file = input()
with open(instructionmemory_file, 'w') as g:
    g.write('v3.0 hex words addressed')
    counter = 0
    while (counter != len(hexArray)):
        if (counter % 16 == 0):
            if (counter == 0):
                g.write('\n' + hex(counter)[2:4] + '0: ')
            else:
                g.write('\n' + hex(counter)[2:4] + ': ')

        g.write(hexArray[counter]+' ')
        counter += 1
        #g.write()


    g.close()