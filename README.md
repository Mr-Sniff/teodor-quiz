# Quiz

Skapa din kopia med *Use this template* och klona den. 

Jobba i det klonade repot. Committa och pusha minst en gång varje lektion, även om koden inte går att köra.

## 1. En fråga som säger nej

Repot har två filer. Öppna **inte** `question.rb` än.

1. Kör `ruby quiz.rb`. Svara på de tre frågorna.
2. Öppna `quiz.rb`. Lägg till tre egna frågor i listan. Kör igen.
3. Starta `irb` i repots mapp och skriv:

```ruby
require_relative "question"
q = Question.new("Vad heter huvudstaden i Norge?", "Oslo")
q.correct?("oslo")
q.correct?("Bergen")
q.prompt
puts q
q.class
q.method(:correct?).owner
```

Vad är `q`? Vilka meddelanden svarar det på? 

Vem bestämmer vad `correct?` betyder?

### Läs

Nu öppnar du `question.rb`. Läs den med orden från presentationen.

- `class Question ... end`. 
  
  Samma rad som `class Array` förra veckan. 
  
  Allt mellan raderna  blir meddelanden som en `Question` svarar på. 
  Skillnaden: `Array` är en inbyggd klass. `Question` skapas i den här filen.
  
- `def correct?(reply)`. 
  Här bor beslutet. `q.method(:correct?).owner` pekade hit.
  Frågetecknet är en konvention i Ruby, inte en regel: metoder som returnerar `true` eller `false` slutar med frågetecken. Du har sett `even?`, `empty?`, `positive?`. 
  
- `def initialize(prompt, answer)`.
  Det här körs när du skickar `new` till `Question`.
  `new` skapar ett tomt objekt och skickar `initialize` till det, tillsammans med argumenten som skickades till `new`.
  
- `@prompt` och `@answer`. 
  Objektets eget state. 
  
  Varje fråga har sitt eget `@answer`. `@` betyder: det här tillhör objektet, inte metoden.
  
- `def prompt` och `def answer`. Två meddelanden som svarar med vad som står i minnet.
  Utan dem kommer ingen åt `@answer` utifrån. 
  
- def answer=(new_answer)
  Ett meddelande som heter `answer=`, med lika-med i namnet.
   `q.answer = "x"` är kortform för `q.answer=("x")`, precis som `"hej"[0] = "H"`  är en kortform för  `"hej".[]=(0, "H")`. 

### Tuffa till frågan

Frågan är för snäll. Prova i irb:

```ruby
Question.new("", "")
q = Question.new("Vad heter huvudstaden i Norge?", "Oslo")
q.answer = "Bergen"
q.correct?("Oslo")
```

En fråga utan text och utan svar gick att skapa. 
Och vem som helst som håller i `q` kan byta ut det rätta svaret. 

Ingen sa nej. Det är samma butik som i kapitel 1, innan varan lärde sig säga nej.

Två ändringar i `question.rb`:

1. **Vägra bli till utan text.** 

2. **Ta bort möjligheten att byta svar.** 

Kör sedan `ruby quiz.rb`. Fungerar det fortfarande? Om något gick sönder var det en rad
som gick in i frågan utifrån. Hitta den och fundera på om den borde finnas.

Kontrollera:

```ruby
Question.new("", "Oslo")        # ArgumentError: prompt must not be empty
q.answer = "x"                  # NoMethodError: undefined method 'answer='
q.answer                        # => "Oslo"   att läsa går bra, det meddelandet finns
```

### Kortform

`def prompt` och `def answer` är sex rader som gör samma sak. Ruby har en kortform:

```ruby
attr_reader :prompt, :answer
```

En rad, överst i klassen, som skriver de två metoderna åt dig. 

Byt ut dina manuellt skapade prompt och answer-metoder. 

### Frågan skvallrar

Om man kör  `puts q` skrivs svaret ut, varför det?

Ska frågan visa svaret?

Bestäm, ändra eller låt vara, och skriv i loggboken varför. Det är ditt första beslut om vilka meddelanden ett objekt ska svara på.

### Vidare

För dig som är klar.

- **En ledtråd.**
  
  Ge `Question` ett nytt meddelande, `hint`, som svarar med svarets första bokstav. Använd det i `quiz.rb` när någon svarar fel första gången. Vem bestämde hur en ledtråd ser ut, frågan eller quizet?
  
- **Ett quiz som är ett objekt.** 
  
  Bygg om `quiz.rb`: en klass `Quiz` som får listan med frågor när den skapas och svarar på `run`. 
  
  Vad äger den? Vem räknar poängen? Vem ställer frågorna? Skriv i loggboken vad du la i `Quiz` och vad du lät `Question` behålla.
  
- **Frågor ur en databas.** 
  För dig som har sett SQL. Skapa `quiz.db` med en tabell `questions(prompt, answer)` och tre rader. Läs raderna med `sqlite3`-gemen och bygg `Question`-objekt av dem i `quiz.rb`. 
  
  Fråga i loggboken: ska `Question` kunna läsa från databasen själv, eller ska något annat bygga frågor av rader? (Kräver att
  `gem install sqlite3` fungerar på din dator. Om det inte gör det, säg till.)

### Loggbok

De vanliga fyra frågorna, och två till:

- Vem kontrollerar svaret, `Question` eller `quiz.rb`? Behöver `quiz.rb` kunna läsa `answer` över huvud taget? 
  Titta på raden `Rätt svar: #{q.answer}`.
- Vad bestämde du om `to_s`, och varför?

## 2. En fråga med alternativ

Två saker den här veckan. Först lär du frågan att bevisa att den fungerar. Sedan
skriver du en andra sorts fråga, och upptäcker något.

### Testa

Förra veckan skrev du i irb:

```ruby
q = Question.new("Vad heter huvudstaden i Norge?", "Oslo")
q.correct?("oslo")    # => true
```

Ett meddelande, ett svar. Du tittade på svaret och tänkte "rätt". Ett test är samma
sak, nedskrivet, så att datorn tittar åt dig. Varje gång.

Först hela cykeln från presentationen på något som inte kan gå fel: ett meddelande som
inte finns än. `hint` ska svara med svarets första bokstav.

**Red.** Skapa mappen `test` och filen `test/question_test.rb`:

```ruby
require "minitest/autorun"
require_relative "../question"

class QuestionTest < Minitest::Test
  def test_hint_is_first_letter_of_answer
    q = Question.new("Vad heter huvudstaden i Norge?", "Oslo")
    assert_equal "O", q.hint
  end
end
```

Kör `ruby test/question_test.rb`. Läs vad som står:

```
NoMethodError: undefined method 'hint' for an instance of Question
1 runs, 0 assertions, 0 failures, 1 errors, 0 skips
```

Rött. Bra. Nu vet du att testet ser koden. Ett test som är grönt från början kan vara
grönt av fel skäl. (Gjorde du ledtråden förra veckan är det grönt redan. Läs vidare
ändå, det andra testet är till för dig också.)

**Green.** Det minsta som gör testet grönt. Det minsta:

```ruby
def hint
  "O"
end
```

Kör igen. `1 runs, 1 assertions, 0 failures`. Grönt, och fusk. Grönt betyder att testet
går igenom, inte att koden är rätt. Så du lägger till ett test till, med en annan fråga:

```ruby
def test_hint_for_another_question
  q = Question.new("Vad heter huvudstaden i Sverige?", "Stockholm")
  assert_equal "S", q.hint
end
```

Rött igen: `Expected: "S"`, `Actual: "O"`. Fusket gick så länge det bara fanns en fråga.

**Refactor.** Nu koden du menade: svarets första tecken. Kör. `2 runs, 2 assertions,
0 failures`. Du ändrade koden, rörde inte testerna, och det förblev grönt.

Så läser du filen:

- `assert_equal x, y` betyder: jag påstår att `y` är `x`. Det väntade först, sedan det
  du fick. Blandar du ordningen blir felmeddelandet bakvänt.
- Varje metod som börjar med `test_` är ett påstående som körs. Namnet är en mening.
- `assert_equal` ser ut som ett anrop utan objekt. Det är ett meddelande till `self`,
  testet självt, som svarar på det för att `QuestionTest < Minitest::Test`. Samma sak
  med `puts` och `raise` inuti `Question`: ingen punkt betyder att mottagaren är
  objektet du står i. En rad till i kortformstabellen: `assert_equal x, y` är
  `self.assert_equal(x, y)`.

Nu två tester på det frågan redan kunde. Lägg till dem i samma klass:

```ruby
def test_correct_ignores_case
  q = Question.new("Vad heter huvudstaden i Norge?", "Oslo")
  assert q.correct?("oslo")
  refute q.correct?("Bergen")
end

def test_refuses_empty_prompt
  assert_raises(ArgumentError) { Question.new("", "Oslo") }
end
```

- `assert x` betyder: jag påstår att `x` är sant. `refute x`: jag påstår att det är falskt.
- `assert_raises(ArgumentError) { ... }`: jag påstår att koden i blocket säger nej.

Kör. `4 runs, 5 assertions, 0 failures`. Gröna från början, för koden fanns redan. Så
gör ett test fel med flit: byt `"oslo"` mot `"bergen"` och kör igen. Läs vad som står.
Byt tillbaka.

Lägg till ett test för det du bestämde om `to_s` förra veckan. Om du lät frågan skvallra,
testa att den gör det. Om inte, testa att den inte gör det.

Varför går `correct?` och `hint` att testa men inte `ask`? Titta på vad `ask` gör på sin
andra rad.

### Bygg

Ett quiz med bara fritextfrågor blir tråkigt. Nästa sort är en fråga med alternativ.
Så här ska den bete sig:

- `MultipleChoice.new(prompt, alternatives, answer)`. `alternatives` är en lista med
  strängar. `answer` är en av dem.
- `ask` skriver ut frågan och alternativen numrerade från 1, och läser ett svar.
- `correct?(reply)` svarar `true` om siffran i `reply` pekar på rätt alternativ.
  `reply.to_i` gör `"2"` till `2`.
- Samma regler som för `Question`: tom text säger nej. Dessutom: `answer` måste finnas
  bland alternativen, annars `ArgumentError`.
- `prompt`, `answer` och `alternatives` går att läsa. Inget går att ändra utifrån.

Den här gången skriver du testerna **innan** klassen finns. Punkterna ovan är
påståenden; skriv av dem som tester i `test/multiple_choice_test.rb`: rätt siffra, fel
siffra, och att en fråga vars svar inte finns bland alternativen säger nej. Överst:
`require_relative "../multiple_choice"`.

Kör testfilen. Rött, redan på första raden: `cannot load such file`. Bra. Nu vet du att
testet märker när klassen saknas.

Skapa `multiple_choice.rb` och skriv klassen tills testerna är gröna. Kör dem ofta,
efter varje metod. Varje gång ett test går från rött till grönt var det testet som sa
till dig att du var klar.

Lägg två flervalsfrågor i listan i `quiz.rb` och kör. Fungerar `quiz.rb` utan att du
ändrar loopen? Varför?

### Läs

Öppna `question.rb` och `multiple_choice.rb` bredvid varandra.

Vilka rader är exakt likadana? Räkna dem.

### Ärv

Det du hittade har ett namn. Ruby låter en klass ta över allt en annan klass svarar på:

```ruby
class MultipleChoice < Question
```

Pilen betyder: `MultipleChoice` är en `Question`, plus något mer. Alla meddelanden
`Question` svarar på svarar nu `MultipleChoice` också på, utan att du skriver dem.

1. Lägg till `< Question` och `require_relative "question"` överst.
2. Ta bort allt i `MultipleChoice` som `Question` redan gör. `prompt`, `answer`,
   `to_s`, de två första reglerna i `initialize`.
3. `initialize` behöver fortfarande finnas, för `MultipleChoice` tar tre argument.
   Låt den skicka vidare det `Question` ska ha:

   ```ruby
   def initialize(prompt, alternatives, answer)
     super(prompt, answer)
     raise ArgumentError, "answer must be one of the alternatives" unless alternatives.include?(answer)
     @alternatives = alternatives
   end
   ```

   `super` betyder: kör `Question`s `initialize` med de här argumenten. Sedan fortsätter
   din egen.
4. `ask` och `correct?` behåller du. De gör något annat än `Question`s. När båda finns
   vinner den i `MultipleChoice`.

Kör båda testfilerna. Om allt är grönt gjorde du rätt. Det är det tester är till för: du
byggde om hela klassen och vet att inget gick sönder.

Det har ett namn: red, green, refactor. Rött när testet finns men inte koden. Grönt när
koden finns. Refactor när du bygger om koden utan att röra testerna, och det förblir grönt.
Du gjorde alla tre i dag, på `hint` i morse och på en hel klass nu.

Kontrollera i irb:

```ruby
q = MultipleChoice.new("Störst?", ["Oslo", "Bergen"], "Oslo")
MultipleChoice.superclass        # => Question
q.method(:prompt).owner          # => Question         ärvt
q.method(:correct?).owner        # => MultipleChoice   eget
q.is_a?(Question)                # => true
```

### Sant eller falskt

En sort till, i `true_false.rb`. `TrueFalse.new("Oslo ligger i Norge", true)`. `ask`
skriver frågan och `(sant/falskt)`. Svaret jämförs med `"sant"` eller `"falskt"`.

Tester först, i `test/true_false_test.rb`. Rött. Skriv sedan klassen med `< Question`
från början, tills det är grönt. Hur många rader blev den?

### Vidare

För dig som är klar.

- **Quiz-klassen**, om du inte gjorde den förra veckan.
- **En ledtråd för flerval.** Vad betyder `hint` för en fråga med alternativ? Ta bort
  ett fel alternativ? Visa första bokstaven? Vem bestämmer, `Question` eller
  `MultipleChoice`? Om `MultipleChoice` bestämmer själv, är det en rad med `super` i
  eller inte?
- **Databasen**, fortsättning. Tre sorters frågor i samma tabell: lägg till en kolumn
  `type`. När du läser raderna, vem bestämmer vilken klass som ska skapas?

### Loggbok

De vanliga fyra, och tre till:

- Vad behöll `MultipleChoice` själv, och vad tog den från `Question`? Varför just det?
- Hur vet du att inget gick sönder när du byggde om?
- `q.method(:correct?).owner` svarar olika för en `Question` och en `MultipleChoice`.
  Förklara med dina egna ord vad `owner` säger.
