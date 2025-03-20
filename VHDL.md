- IEEE: Institute of Electrical and Electronics Engineers,<br/>
vhdl'87 (IEEE 1076-1987)<br/>
vhdl'93 (IEEE 1076-1993)<br/>
- They keep the same number(1076) but update the year when a new revision is published

***
> A production consists of a left-hand side (::=) readen as “can be replaced by” and a right-hand side.<br/>
> The left-hand side of a production is always a syntactic category; the right-hand side is a replacement rule<br/>
***
### Types and Subtypes
- TYPE
```vhdl
-- example one
TYPE StateMachine IS (start, count, steady);
SIGNAL state, nextState : StateMachine;

-- example two
TYPE Weight IS RANGE 0 TO 10_000
   UNITS
     gr;
     kg  = 1000 gr;
     ton = 1000 kg;
   END UNITS;

```
**Is equivalent to**
```c
// example 1
typedef enum { START, COUNT, STEADY } StateMachine;
StateMachine state, nextState;

// example 2
typedef struct {
    int value;  // Stores weight in grams
} Weight;
#define KG(x)  ((x) * 1000)  // Convert kg to grams
#define TON(x) ((x) * 1000000)  // Convert ton to grams

Weight w1 = {500};   // 500 grams
Weight w2 = {KG(2)}; // 2 kg → 2000 grams
Weight w3 = {TON(1)}; // 1 ton → 1,000,000 grams
```

- **SUBTYPE**
SUBTYPE is not a new type—it’s just a restriction on an existing type
```vhdl
SUBTYPE MyArray IS BIT_VECTOR(7 DOWNTO 3);
```
- `BIT_VECTOR` is an existing type
- `MyArray` only allows bits 7 to 3

***

# ENTITY DECLARATION
- definesthe interface between a given design entity environment
- specify declaration and design entity
- **class** of design entities

1. **Simple entity implementation**
```vhdl
ENTITY ExFlipFlop IS
    PORT (
	CLK     : IN  STD_LOGIC;  -- Input
	Y       : OUT STD_LOGIC;  -- Output
	D       : INOUT STD_LOGIC   -- bidirectional
    );
END ENTITY ExFlipFlop;
```
2. **Detailed**
**Syntax:**
```vhdl
entity_declaration ::=
    entity identiﬁer is
	entity_header
	entity_declarative_part
    [ begin
	entity_statement_part ]
    end [ entity ] [ entity_simple_name ] ;
```
**Example:**
```vhdl
ENTITY AND_GATE IS
    PORT (
        A : IN  STD_LOGIC;  -- Input A
        B : IN  STD_LOGIC;  -- Input B
        Y : OUT STD_LOGIC   -- Output Y
    );
END ENTITY AND_GATE;
```

1. `ENTITY name_entity IS`
- ENTITY: Indicate start of entity declaration

2. `entity_header`
```vhdl
PORT (
    A : IN  STD_LOGIC;
    B : IN  STD_LOGIC;
    Y : OUT STD_LOGIC
)
```
- It defines the ports of entity, with its directions.

3. `entity_declarative_part`
```vhdl
TYPE State_Type IS (start, count, steady);
```
- It is used to declare other types like `type`, `subtype`, Constants, Signals.
- it is optional

4. `[BEGIN entity_statement_part]`
- It can be used if you want to define specific behavior or actions at entity level.
- rarely used

5. `END [ENTITY] [entity_name];`
```vhdl
END ENTITY AND_GATE;
```
- to end the entity declaration
***
# ARCHITECUTRE DECLARATION PART <br/>
- contains declarations of items available for use defined in design entity. <br/>
**SYNTAX:** <br/>
architecture_declarative_part ::= <br/>
{block_declarative_item} <br/>
<br/>
block_declarative_item ::= <br/>
    subprogram_declaration <br/>
    | subprogram_body <br/>
    | type_declaration <br/>
    | subtype_declaration <br/>
    | constant_declaration <br/>
    | signal_declaration <br/>
    | shared_variable_declaration <br/>
    | ﬁle_declaration <br/>
    | alias_declaration <br/>
    | component_declaration <br/>
    | attribute_declaration <br/>
    | attribute_speciﬁcation <br/>
    | conﬁguration_speciﬁcation <br/>
    | disconnection_speciﬁcation <br/>
    | use_clause <br/>
    | group_template_dec <br/>
<br/>
**STATEMENT PART** <br/>

```vhdl
ARCHITECTURE architecture_name OF entity_name IS
    SIGNAL A, B: BIT;
BEGIN
    A <= X XOR Y;
    B <= A AND Cin;
    Cout <= B OR (X AND Y);
END ARCHITECTURE architecture_name
```
***
# CONFIGURATION DECLARATIONS <br/>
***
```vhdl
ARCHITECTURE Structure_View OF entity_name IS
    component ALU port ( ••• ); end component;
    component MUX port ( ••• ); end component;
    component Latch port ( ••• ); end component;
BEGIN
    A1: ALU port map ( ••• );
    M1: MUX port map ( ••• );
    M2: MUX port map ( ••• );
    M3: MUX port map ( ••• );
    L1: Latch port map ( ••• );
    L2: Latch port map ( ••• );
END Structure_View;
```
***
### ARRAY
- **Syntax**
```vhdl
TYPE array_name IS ARRAY (index_range) OF element_type;
SIGNAL array_one: array_name;

TYPE IS ARRAY (index_range) OF element_type;
```