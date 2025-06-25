def make_pizza(size,*toppings):
    print(f'\nMaking {size} with:')
    for topping in toppings:
        print(f'- {topping}')