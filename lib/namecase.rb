module NameCase
  VERSION = '1.2.0'

  # Returns a new +String+ with the contents properly namecased
  def nc(options = {})
    options = { :lazy => true, :irish => true, :international => true}.merge options

    # Skip if string is mixed case
    if options[:lazy]
      first_letter_lower = self[0] == self.downcase[0]
      all_lower_or_upper = (self.downcase == self || self.upcase == self)

      return self unless first_letter_lower || all_lower_or_upper
    end

    localstring = downcase
    localstring.gsub!(/\b\w/) { |first| first.upcase }
    localstring.gsub!(/\'\w\b/) { |c| c.downcase } # Lowercase 's

    if options[:irish]
      if localstring =~ /\bMac[A-Za-z]{2,}[^aciozj]\b/ or localstring =~ /\bMc/
        match = localstring.match(/\b(Ma?c)([A-Za-z]+)/)
        localstring.gsub!(/\bMa?c[A-Za-z]+/) { match[1] + match[2].capitalize }

        # Now fix "Mac" exceptions
        localstring.gsub!(/\bMacEdo/, 'Macedo')
        localstring.gsub!(/\bMacEvicius/, 'Macevicius')
        localstring.gsub!(/\bMacHado/, 'Machado')
        localstring.gsub!(/\bMacHar/, 'Machar')
        localstring.gsub!(/\bMacHin/, 'Machin')
        localstring.gsub!(/\bMacHlin/, 'Machlin')
        localstring.gsub!(/\bMacIas/, 'Macias')
        localstring.gsub!(/\bMacIulis/, 'Maciulis')
        localstring.gsub!(/\bMacKie/, 'Mackie')
        localstring.gsub!(/\bMacKle/, 'Mackle')
        localstring.gsub!(/\bMacKlin/, 'Macklin')
        localstring.gsub!(/\bMacKmin/, 'Mackmin')
        localstring.gsub!(/\bMacQuarie/, 'Macquarie')
      end
      localstring.gsub!('Macmurdo','MacMurdo')
    end

    if options[:international]
      # Fixes for "son (daughter) of" etc
      localstring.gsub!(/\bAl(?=\s+\w)/, 'al')  # al Arabic or forename Al.
      localstring.gsub!(/\bAp\b/, 'ap')         # ap Welsh.
      localstring.gsub!(/\bBen(?=\s+\w)/,'ben') # ben Hebrew or forename Ben.
      localstring.gsub!(/\bDell([ae])\b/,'dell\1')  # della and delle Italian.
      localstring.gsub!(/\bD([aeiou])\b/,'d\1')   # da, de, di Italian; du French; do Brasil
      localstring.gsub!(/\bD([ao]s)\b/,'d\1')   # das, dos Brasileiros
      localstring.gsub!(/\bDe([lr])\b/,'de\1')   # del Italian; der Dutch/Flemish.
      localstring.gsub!(/\bEl\b/,'el')   # el Greek or El Spanish.
      localstring.gsub!(/\bLa\b/,'la')   # la French or La Spanish.
      localstring.gsub!(/\bL([eo])\b/,'l\1')      # lo Italian; le French.
      localstring.gsub!(/\bVan(?=\s+\w)/,'van')  # van German or forename Van.
      localstring.gsub!(/\bVon\b/,'von')  # von Dutch/Flemish
    end

    # Fix roman numeral names
    localstring.gsub!(
      / \b ( (?: [Xx]{1,3} | [Xx][Ll]   | [Ll][Xx]{0,3} )?
             (?: [Ii]{1,3} | [Ii][VvXx] | [Vv][Ii]{0,3} )? ) \b /x
    ) { |match| match.upcase }

    localstring
  end

  # Modifies _str_ in place and properly namecases the string.
  def nc!(options = {})
    self.gsub!(self, self.nc(options))
  end
end

def NameCase(string, options = {})
  string.dup.extend(NameCase).nc(options)
end

def NameCase!(string, options = {})
  string.extend(NameCase).nc!(options)
end
