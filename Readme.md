# Run `VHDL` file with `GDHL`

**Program**
-- Import packages
-- Define entity
-- Define architecture

> file name: hello.vhdl
**1. We need to compile the file**
```sh
ghdl -a hello.vhdl
```
- This updates a file work-obj93.cf, which describes library 'work'.
> in linux, it generates `hello.o` <br>
> in windows, Object file is `not created`
***
**2. Build an executable file**
> entity name: hello_world
```sh 
ghdl -e hello_world
```
- **-e: elaborate**
- it generates the executable hello_world

***
**3. Run the executable**
## for GNU/Linux:
```sh 
ghdl -r hello_world
```
**OR**
```sh 
./hello_world
```
## for Windows:
- no file is created.
```sh 
ghdl -r hello_world
```
