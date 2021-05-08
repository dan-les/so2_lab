#!/usr/bin/python3
# Daniel Leśniewicz
"""Kółko i krzyżyk"""

import os
import random
import sys
import time


def choose_symbol():
    """Funkcja zwracająca zestaw symboli, którymi posługuje się gracz zwykłay oraz komputer"""
    player = input("Wybierz swój symbol: 'X' lub 'O' ")
    player = player.upper()
    while True:
        if player == 'X':
            computer_player_symbol = 'O'
            break
        if player == 'O':
            computer_player_symbol = 'X'
            break
        if player not in 'X' and player not in 'O':
            player = input("Możesz wybrać tylko 'X' lub 'O' ")
            player = player.upper()
    return player, computer_player_symbol


def check_if_someone_win_a_game(brd_crds, symbol):
    """Funkcja zwracająca True jeśli gracz o danym symbolu wygrał lub False w przeciwnym wypadku"""
    for cord in [0, 3, 6]:
        if brd_crds[cord] == brd_crds[cord + 1] == brd_crds[cord + 2] == symbol:
            return True

    for cord in [0, 1, 2]:
        if brd_crds[cord] == brd_crds[cord + 3] == brd_crds[cord + 6] == symbol:
            return True

    if brd_crds[0] == brd_crds[4] == brd_crds[8] == symbol or \
            brd_crds[6] == brd_crds[4] == brd_crds[2] == symbol:
        return True

    return False


def check_rows(cord, brd_crds, symbol_null, symbol_player):
    """ Funkcja zwracająca współrzędną jeśli można zablokowac
    przeciwnika w wierszu lub -1 w przeciwnym wypadku"""
    if brd_crds[cord] == brd_crds[cord + 1] == symbol_player and \
            brd_crds[cord + 2] == symbol_null:
        return cord + 2
    if brd_crds[cord] == brd_crds[cord + 2] == symbol_player and \
            brd_crds[cord + 1] == symbol_null:
        return cord + 1
    if brd_crds[cord + 1] == brd_crds[cord + 2] == symbol_player and \
            brd_crds[cord] == symbol_null:
        return cord
    return -1


def check_columns(cord, brd_crds, symbol_null, symbol_player):
    """ Funkcja zwracająca współrzędną jeśli można zablokowac
    przeciwnika w kolumnie lub -1 w przeciwnym wypadku"""
    if brd_crds[cord] == brd_crds[cord + 3] == symbol_player and \
            brd_crds[cord + 6] == symbol_null:
        return cord + 6
    if brd_crds[cord] == brd_crds[cord + 6] == symbol_player and \
            brd_crds[cord + 3] == symbol_null:
        return cord + 3
    if brd_crds[cord + 3] == brd_crds[cord + 6] == symbol_player and \
            brd_crds[cord] == symbol_null:
        return cord
    return -1


def check_diagonal_one(brd_crds, symbol_null, symbol_player):
    """ Funkcja zwracająca współrzędną jeśli można zablokowac
        przeciwnika po przekątnej (w górę) lub -1 w przeciwnym wypadku"""
    if brd_crds[0] == brd_crds[4] == symbol_player and brd_crds[8] == symbol_null:
        return 8
    if brd_crds[0] == brd_crds[8] == symbol_player and brd_crds[4] == symbol_null:
        return 4
    if brd_crds[4] == brd_crds[8] == symbol_player and brd_crds[0] == symbol_null:
        return 0
    return -1


def check_diagonal_two(brd_crds, symbol_null, symbol_player):
    """ Funkcja zwracająca współrzędną jeśli można zablokować
        przeciwnika po przekątnej (w dół) lub -1 w przeciwnym wypadku"""
    if brd_crds[6] == brd_crds[4] == symbol_player and brd_crds[2] == symbol_null:
        return 2
    if brd_crds[6] == brd_crds[2] == symbol_player and brd_crds[4] == symbol_null:
        return 4
    if brd_crds[2] == brd_crds[4] == symbol_player and brd_crds[6] == symbol_null:
        return 6
    return -1


def make_clever_move(brd_crds, symbol_null, symbol):
    """Funkcja pozwalajaca wykonać odpowiedni ruch komputerowi"""
    # możliwości dla wierszy 1-3
    for cord in [0, 3, 6]:
        tmp = check_rows(cord, brd_crds, symbol_null, symbol)
        if tmp != -1:
            return tmp
    # możliwości dla kolumn 1-3
    for cord in [0, 1, 2]:
        tmp = check_columns(cord, brd_crds, symbol_null, symbol)
        if tmp != -1:
            return tmp
    # możliwości dla przekątnych - \
    tmp = check_diagonal_one(brd_crds, symbol_null, symbol)
    if tmp != -1:
        return tmp
    # możliwości dla przekątnych - /
    tmp = check_diagonal_two(brd_crds, symbol_null, symbol)
    if tmp != -1:
        return tmp
    return -1


def cord_choice(brd_crds, if_computer, symbol_player, symbol_computer, symbol_null):
    """Funkcja zwracająca symbol, który wybrał gracz (komputer też jest graczem)"""
    if if_computer:
        # wybór prowadzący komputer do wygranej
        tmp = make_clever_move(brd_crds, symbol_null, symbol_computer)
        if tmp != -1:
            return tmp

        temporary_computer_iq = random.randint(80, 150)
        # sprawdzamy prawdopodobieństwo czy komputer wybierze
        # mądre rozwiązanie, aby zablokować przeciwnika
        if temporary_computer_iq > 120:
            # wybór prowadzący komputer do blokady wygranej przeciwnika
            tmp = make_clever_move(brd_crds, symbol_null, symbol_player)
            if tmp != -1:
                return tmp

        # pozostałe przypadki
        rand = random.randint(0, 8)
        while brd_crds[int(rand)] != symbol_null:
            rand = random.randint(0, 8)
        return rand

    choice = input("Podaj miejsce do wstawienia symbolu: ")
    while int(choice) > 10 or int(choice) < 1 or brd_crds[int(choice) - 1] != symbol_null:
        print("Miejsce już zajęte lub niepoprawny numer!")
        return cord_choice(brd_crds, False, symbol_player, symbol_computer, symbol_null)
    return int(choice) - 1


BOARD_WITH_CORDS = ("         P L A N S Z A         \n"
                    "###############################\n"
                    "#         #         #         #\n"
                    "#    1    #    2    #    3    #\n"
                    "#         #         #         #\n"
                    "###############################\n"
                    "#         #         #         #\n"
                    "#    4    #    5    #    6    #\n"
                    "#         #         #         #\n"
                    "###############################\n"
                    "#         #         #         #\n"
                    "#    7    #    8    #    9    #\n"
                    "#         #         #         #\n"
                    "###############################\n")


def display_board_with_symbols(board_cords_to_process):
    """Funkcja wyświetlająca aktualną planszę"""
    new_board = BOARD_WITH_CORDS
    for index in range(0, 9):
        if board_cords_to_process[index] == '_':
            new_board = new_board.replace(str(index + 1), ' ')
        else:
            new_board = new_board.replace(str(index + 1), board_cords_to_process[index])
    print(new_board)


if __name__ == "__main__":
    print('GRA - Kółko i Krzyżyk')
    i = 0
    NULL_SYMBOL = "_"
    BOARD_CORDS = [NULL_SYMBOL] * 9
    print("-------- NUMERACJA PÓL --------")
    print(BOARD_WITH_CORDS)

    PLAYER_SYMBOL, COMPUTER_SYMBOL = choose_symbol()
    input("Naciśnij dowolny klawisz, aby rozpocząć grę...")
    os.system('clear')
    display_board_with_symbols(BOARD_CORDS)

    while True:
        if i % 2 == 0:
            SYMBOL = PLAYER_SYMBOL
            COMPUTER = False
        else:
            print("Komputer myśli (｡◕‿‿◕｡)")
            time.sleep(random.randint(2, 3))
            SYMBOL = COMPUTER_SYMBOL
            COMPUTER = True

        POSITION = cord_choice(BOARD_CORDS, COMPUTER, PLAYER_SYMBOL, COMPUTER_SYMBOL, NULL_SYMBOL)
        os.system('clear')
        BOARD_CORDS[POSITION] = SYMBOL
        display_board_with_symbols(BOARD_CORDS)
        i += 1

        if check_if_someone_win_a_game(BOARD_CORDS, COMPUTER_SYMBOL):
            print("Przegrałeś! ᕙ(⇀‸↼‶)ᕗ")
            sys.exit(0)
        if check_if_someone_win_a_game(BOARD_CORDS, PLAYER_SYMBOL):
            print("Wygrałeś! (ʘ‿ʘ)")
            sys.exit(0)
        if i == 9:
            print("Nikt nie wygrał! (￣෴￣)")
            sys.exit(0)
