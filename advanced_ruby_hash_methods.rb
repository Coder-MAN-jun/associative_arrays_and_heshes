# Numbers can be hash keys
{1 => "one"}[1] # "one"

# So can the Ruby kernel
{Kernel => 1}[Kernel] # 1

# You can store values for specific classes
{Kernel => 1, String => 2}["hello world".class] # 2

# You can store values for booleans
{true => "verdad"}[1==1] # "verdad"

# You can even use complex arrays and even other hashes as hash keys
{[[1,0],[0,1]] => "identity matrix"}[[[1,0], [0,1]]] # "identity matrix"

# ---

# У вас есть контроль над значением по умолчанию. 
h = Hash.new("This attribute intentionally left blank")
h[:a] = 1
h[:a] # 1
h[:x] # "This attribute intentionally left blank"

# ---

# Динамические значения по умолчанию 
h = Hash.new { |hash, key| "#{key}: #{ Time.now.to_i }" }
h[:a] # "a: 1435682937"
h[:a] # "a: 1435682941"
h[:b] # "b: 1435682943"

# ---

# Вызов исключения, если хеш-ключ отсутствует 
h = Hash.new { |hash, key| raise ArgumentError.new("No hash key: #{ key }") }
h[:a]=1
h[:a] # 1
h[:x] # raises ArgumentError: No hash key: x

# ---

# Лениво генерируемые таблицы поиска 
sqrt_lookup = Hash.new { |hash, key| hash[key] = Math.sqrt(key) }
sqrt_lookup[9] # 3.0
sqrt_lookup[7] # 2.6457513110645907
sqrt_lookup    # {9=>3.0, 7=>2.6457513110645907}

# ---

# Рекурсивные ленивые таблицы поиска 
factorial = Hash.new do |h,k| 
  if k > 1
    h[k] = h[k-1] * k
  else
    h[k] = 1
  end
end

factorial[4] # 24
factorial    # {1=>1, 2=>2, 3=>6, 4=>24}

# ---

# Изменение значений по умолчанию после инициализации 
h={}
h[:a] # nil
h.default = "new default"
h[:a] # "new default"

h.default_proc = Proc.new { Time.now.to_i }
h[:a] # 1435684014

# ---

# Find the Ruby: игра с лениво бесконечными вложенными хэшами 
generator = Proc.new do |hash, key| 
  hash[key] = Hash.new(&generator).merge(["n", "s", "e", "w"][rand(4)] => "You found the ruby!")
end
dungeon = Hash.new(&generator)
dungeon["n"] # <Hash ...
dungeon["n"]["s"] # <Hash ...
dungeon["n"]["s"]["w"] # "You found the ruby!"
