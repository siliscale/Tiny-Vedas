# Open the decode table file
import sys
import os, tempfile
import re
import subprocess

with open(sys.argv[1], 'r') as f:
    lines = f.readlines()

# Get the indexes of .definition, .input, .ouput, .decode and .end
definition_idx = None
input_idx = None
output_idx = None
decode_idx = None
end_idx = None

for i, line in enumerate(lines):
    if line.startswith('.definition'):
        definition_idx = i
    elif line.startswith('.input'):
        input_idx = i
    elif line.startswith('.output'):
        output_idx = i
    elif line.startswith('.decode'):
        decode_idx = i
    elif line.startswith('.end'):
        end_idx = i

# Let's create a temp file for the decodes
outputs = []
instr_encoding = {}
decode_file = tempfile.NamedTemporaryFile(delete=True)
with open(decode_file.name, 'w') as f:
    f.write(".i 32\n")
    # Calculate the output
    for i in range(output_idx + 1, decode_idx):
        if "{" not in lines[i] and "}" not in lines[i] and lines[i].strip() != "":
            outputs.append(lines[i].strip())
    f.write(f".o {len(outputs)}\n")
    f.write(f".ilb ")
    for i in range (32):
        f.write(f"i[{31 - i}] ")
    f.write("\n")
    f.write(f".ob ")
    for output in outputs:
        f.write(f"{output} ")
    f.write("\n")

    # Generate the input matching expressions
    for i in range(definition_idx + 1, input_idx):
        if "=" in lines[i]:
            l = lines[i].strip().split("=")
            instr_name = l[0].strip()
            encoding = l[1].strip().lstrip("[").rstrip("]")
            encoding = encoding.replace(".", "-")
            instr_encoding[instr_name] = encoding
    instr_output = {}

    # Generate the output expresisons
    for i in range(decode_idx + 1, end_idx):
        # Get whatever is between the [] with a regex
        l = re.search(r'\[(.*?)\]', lines[i])
        if l:
            instr_name = l.group(1).strip()
        # Get wathever is in between the {} with a regex
        l = re.search(r'\{(.*?)\}', lines[i])
        if l:
            decoding_expression = []
            # Start from revrse order on the outputs
            for output in outputs:
                if output in l.group(1):
                    decoding_expression.append('1')
                else:
                    decoding_expression.append('0')
            instr_output[instr_name] = ''.join(decoding_expression)
    
    # Make sure that the keys of instr_output are the same as the keys of instr_encoding
    for key in instr_encoding.keys():
        if key not in instr_output.keys():
            # Throw an error
            raise ValueError(f"Instruction {key} not found in the output")
            exit(1)
    
    for key in instr_encoding.keys():
        f.write(f"{instr_encoding[key]} {instr_output[key]} # {key}\n")
    
    f.write(".e\n")

# Let's create the legal encoding file
legal_encoding = tempfile.NamedTemporaryFile(delete=True)
with open(legal_encoding.name, 'w') as f:
    f.write(".i 32\n")
    f.write(".o 1\n")
    f.write(".ilb ")
    for i in range(32):
        f.write(f"i[{31-i}] ")
    f.write("\n")
    f.write(".ob legal\n")
    for key in instr_encoding.keys():
        f.write(f"{instr_encoding[key]} 1 # {key}\n")
    f.write(".e\n")

# Run Espresso on both files and record output on a variable using subprocess
decode_output = subprocess.check_output(f"espresso -o eqntott {decode_file.name}", shell=True)
legal_output = subprocess.check_output(f"espresso -o eqntott {legal_encoding.name}", shell=True)

# Print legal_output
with open(legal_encoding.name, 'r') as f:
    print(f.read())

decode_output = decode_output.decode('utf-8')
legal_output = legal_output.decode('utf-8')

decode_output = decode_output.replace("!", "~")
legal_output = legal_output.replace("!", "~")

# Remove all the lines that start with "#"
decode_output = "\n".join([line for line in decode_output.split("\n") if not line.startswith("#")])
legal_output = "\n".join([line for line in legal_output.split("\n") if not line.startswith("#")])

# Join the two outputs
output = decode_output + legal_output

output = output.split("\n")

for i in range(len(output)):
    if '=' in output[i] :
        output[i] = 'assign decode_out.' + output[i]

output = "\n".join(output)
# Create a new temp file for the system verilog file
system_verilog_file = tempfile.NamedTemporaryFile(delete=True)
with open(system_verilog_file.name, 'w') as f:
    f.write ('module decode (\n')
    f.write ('    input logic [31:0] \t\t\t i,\n')
    f.write ('     output decode_out_t decode_out\n')
    f.write(');\n')
    f.write(output)
    f.write('endmodule\n')
    
# Pass verible-verilog-format and collect the exit code and output
formatted_output = subprocess.check_output(f"verible-verilog-format {system_verilog_file.name}", shell=True)
formatted_output = formatted_output.decode('utf-8')

# open file sys.argv[1] for writing and write the formatted output
with open(f"{sys.argv[1]}.sv", 'w') as f:
    f.write(formatted_output)
    f.close()

# Close all the files
decode_file.close()
legal_encoding.close()
system_verilog_file.close()

print (f"Successfully created {sys.argv[1]}.sv")

## Print the content of the decode file
#with open(decode_file.name, 'r') as f:
#    print(f.read())
#
## Print the content of the legal encoding file
#with open(legal_encoding.name, 'r') as f:
#    print(f.read())


f.close()


