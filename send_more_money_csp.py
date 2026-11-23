import copy
from itertools import product


class CriptoAritm:
    def __init__(self, palabras, dominio):
        self.variables = set(c for c in palabras if c not in ('+', '='))
        self.dominio = dominio.copy()
        self.VarDom = {k: dominio.copy() for k in self.variables}

        # Las letras iniciales de SEND y MORE no pueden ser cero.
        self.VarDom['S'].discard(0)
        self.VarDom['M'].discard(0)



        # Variables auxiliares para los acarreos por columna.
        self.VarDom['C1'] = {0, 1}
        self.VarDom['C2'] = {0, 1}
        self.VarDom['C3'] = {0, 1}
        self.VarDom['C4'] = {1}
        self.variables.update({'C1', 'C2', 'C3', 'C4'})


        self.Constraints = []
        # Contadores compartidos por todas las ramas de búsqueda.
        self.nodosExplorados = [0]
        self.asignacionesProbadas = [0]



    def copy(self):
        instancia = copy.deepcopy(self)
        instancia.nodosExplorados = self.nodosExplorados
        instancia.asignacionesProbadas = self.asignacionesProbadas
        return instancia



    def setConstraint(self, constraint):
        self.Constraints.append(constraint)



    def LT_constraintValue(self, variables, valor):
        AnyChange = False
        for var in variables:
            OldDom = self.VarDom[var].copy()
            self.VarDom[var] = {v for v in self.VarDom[var] if v < valor}
            if self.VarDom[var] != OldDom:
                AnyChange = True
        return AnyChange



    def LTE_constraintValue(self, variables, valor):
        AnyChange = False
        for var in variables:
            OldDom = self.VarDom[var].copy()
            self.VarDom[var] = {v for v in self.VarDom[var] if v <= valor}
            if self.VarDom[var] != OldDom:
                AnyChange = True
        return AnyChange



    def AllDifferent(self, variables):
        AnyChange = False
        variablesAsignadas = [var for var in variables if len(self.VarDom[var]) == 1]
        valoresAsignados = [next(iter(self.VarDom[var])) for var in variablesAsignadas]



        # Dos letras asignadas no pueden compartir el mismo dígito.
        if len(valoresAsignados) != len(set(valoresAsignados)):
            return None



        # Elimina los dígitos asignados de los dominios de las demás letras.
        for varAsignada in variablesAsignadas:
            valor = next(iter(self.VarDom[varAsignada]))
            for var in variables:
                if var != varAsignada and len(self.VarDom[var]) > 1:
                    OldDom = self.VarDom[var].copy()
                    self.VarDom[var].discard(valor)
                    if self.VarDom[var] != OldDom:
                        AnyChange = True
        return AnyChange



    def RestriccionSuma(self, variables):
        AnyChange = False
        dominios = [self.VarDom[var] for var in variables]
        combinaciones = product(*dominios)
        valoresValidos = [set() for _ in variables]



        # a + b = c + 10 * acarreo
        for combinacion in combinaciones:
            a, b, c, acarreo = combinacion
            if a + b == c + 10 * acarreo:
                for i in range(len(combinacion)):
                    valoresValidos[i].add(combinacion[i])



        for i, var in enumerate(variables):
            OldDom = self.VarDom[var].copy()
            self.VarDom[var].intersection_update(valoresValidos[i])
            if self.VarDom[var] != OldDom:
                AnyChange = True
        return AnyChange



    def RestriccionSumaTres(self, variables):
        AnyChange = False
        dominios = [self.VarDom[var] for var in variables]
        combinaciones = product(*dominios)
        valoresValidos = [set() for _ in variables]



        # a + b + c = d + 10 * acarreo
        for combinacion in combinaciones:
            a, b, c, d, acarreo = combinacion
            if a + b + c == d + 10 * acarreo:
                for i in range(len(combinacion)):
                    valoresValidos[i].add(combinacion[i])



        for i, var in enumerate(variables):
            OldDom = self.VarDom[var].copy()
            self.VarDom[var].intersection_update(valoresValidos[i])
            if self.VarDom[var] != OldDom:
                AnyChange = True
        return AnyChange



    def RestriccionM(self, variables):
        AnyChange = False
        M, C4 = variables
        OldDomM = self.VarDom[M].copy()
        OldDomC4 = self.VarDom[C4].copy()
        valoresValidosM = set()
        valoresValidosC4 = set()



        # El acarreo final debe ser igual a M (y C4 está fijado a 1).
        for m in self.VarDom[M]:
            for c4 in self.VarDom[C4]:
                if m == c4:
                    valoresValidosM.add(m)
                    valoresValidosC4.add(c4)
        self.VarDom[M].intersection_update(valoresValidosM)
        self.VarDom[C4].intersection_update(valoresValidosC4)



        if self.VarDom[M] != OldDomM:
            AnyChange = True
        if self.VarDom[C4] != OldDomC4:
            AnyChange = True
        return AnyChange



    def GlobalConsistens(self):
        while True:
            AnyChange = False
            for constraint in self.Constraints:
                nombre = constraint[0]
                parametros = constraint[1]
                cambio = getattr(self, nombre)(parametros)
                if cambio is None:
                    return False
                AnyChange = cambio or AnyChange
            if not AnyChange:
                break
        return self.isConsistent()



    def SeleccionarVariable(self):
        variablesPendientes = [var for var in self.variables if len(self.VarDom[var]) > 1]
        if not variablesPendientes:
            return None
        # MRV: seleccionar la variable con menor dominio restante.
        return min(variablesPendientes, key=lambda var: len(self.VarDom[var]))



    def SeleccionarValores(self, var):
        valores = list(self.VarDom[var])



        # LCV: priorizar valores que aparecen en menos dominios de otras variables.
        def impacto(valor):
            impactoTotal = 0
            for otraVar in self.variables:
                if otraVar != var and len(self.VarDom[otraVar]) > 1:
                    if valor in self.VarDom[otraVar]:
                        impactoTotal += 1
            return impactoTotal
        return sorted(valores, key=impacto)



    def isConsistent(self):
        # No debe existir ningún dominio vacío.
        for var in self.variables:
            if len(self.VarDom[var]) == 0:
                return False



        valoresAsignados = []
        for var in self.variables:
            if len(self.VarDom[var]) == 1:
                valor = next(iter(self.VarDom[var]))
                if var in {'S', 'M'} and valor == 0:
                    return False
                if var not in {'C1', 'C2', 'C3', 'C4'}:
                    if valor in valoresAsignados:
                        return False
                    valoresAsignados.append(valor)
        return True



    def isFullSolution(self):
        return all(len(self.VarDom[var]) == 1 for var in self.variables)



    def isValid(self):
        LetraValor = {var: next(iter(self.VarDom[var])) for var in self.variables}
        S = LetraValor['S']
        E = LetraValor['E']
        N = LetraValor['N']
        D = LetraValor['D']
        M = LetraValor['M']
        O = LetraValor['O']
        R = LetraValor['R']
        Y = LetraValor['Y']



        SEND = S * 1000 + E * 100 + N * 10 + D
        MORE = M * 1000 + O * 100 + R * 10 + E
        MONEY = M * 10000 + O * 1000 + N * 100 + E * 10 + Y

        return (SEND + MORE == MONEY
                and len({S, E, N, D, M, O, R, Y}) == 8
                and S != 0 and M != 0)



    def backtraking(self):
        self.nodosExplorados[0] += 1
        varSel = self.SeleccionarVariable()



        if varSel is None:
            if self.isFullSolution() and self.isValid():
                print('\nSOLUCION ENCONTRADA')
                for var in sorted(self.variables):
                    print(var, '=', next(iter(self.VarDom[var])))



                S = next(iter(self.VarDom['S']))
                E = next(iter(self.VarDom['E']))
                N = next(iter(self.VarDom['N']))
                D = next(iter(self.VarDom['D']))
                M = next(iter(self.VarDom['M']))
                O = next(iter(self.VarDom['O']))
                R = next(iter(self.VarDom['R']))
                Y = next(iter(self.VarDom['Y']))



                SEND = S * 1000 + E * 100 + N * 10 + D
                MORE = M * 1000 + O * 100 + R * 10 + E
                MONEY = M * 10000 + O * 1000 + N * 100 + E * 10 + Y
                print('\nOperacion:')
                print(f'{SEND} + {MORE} = {MONEY}')
                return self.copy()
            return None



        valores = self.SeleccionarValores(varSel)
        for valor in valores:
            self.asignacionesProbadas[0] += 1
            estadoActual = self.copy()
            estadoActual.VarDom[varSel] = {valor}
            if estadoActual.GlobalConsistens():
                resultado = estadoActual.backtraking()
                if resultado is not None:
                    return resultado
        return None



SENDMORE = CriptoAritm('SEND+MORE=MONEY', set(range(10)))

SENDMORE.setConstraint(('AllDifferent', list('SENDMORY')))
SENDMORE.setConstraint(('RestriccionSuma', ['D', 'E', 'Y', 'C1']))
SENDMORE.setConstraint(('RestriccionSumaTres', ['N', 'R', 'C1', 'E', 'C2']))
SENDMORE.setConstraint(('RestriccionSumaTres', ['E', 'O', 'C2', 'N', 'C3']))
SENDMORE.setConstraint(('RestriccionSumaTres', ['S', 'M', 'C3', 'O', 'C4']))
SENDMORE.setConstraint(('RestriccionM', ['M', 'C4']))

print('Dominios iniciales:')
print(SENDMORE.VarDom)
print('\nIniciando Backtracking...\n')

if SENDMORE.GlobalConsistens():
    solucion = SENDMORE.backtraking()
else:
    solucion = None

print('\nRESULTADOS DE LA BUSQUEDA')
print('Nodos explorados:', SENDMORE.nodosExplorados[0])
print('Asignaciones probadas:', SENDMORE.asignacionesProbadas[0])
if solucion is None:
    print('No se encontro una solucion.')
