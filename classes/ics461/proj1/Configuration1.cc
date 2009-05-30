#include "Configuration.h"
#include <iostream>

using namespace std;

Configuration::Configuration(int in_size) {
  size = in_size;
  grid = new int[size*size];
  for (int i = 0; i < size*size; i++) grid[i] = i;
  blank_pos = 0;
  parent = NULL;
}

Configuration::Configuration(const Configuration &c) {
  size = c.size;
  blank_pos = c.blank_pos;
  grid = new int[size*size];
  memcpy(grid, c.grid, size*size*sizeof(int));
  parent = c.parent;
}

Configuration::Configuration(Configuration *c) {
  size = c->size;
  blank_pos = c->blank_pos;
  grid = new int[size*size];
  memcpy(grid, c->grid, size*size*sizeof(int));
  parent = c;
}

Configuration::~Configuration() {
  delete [] grid;
}

Configuration *Configuration::get_parent() {
  return parent;
}

void Configuration::set_parent(Configuration *c) {
  parent = c;
}

void Configuration::print() {
  for (int row = 0; row < size; row++) {
    for (int col = 0; col < size; col++) {
      cout << grid[row*size + col] << " ";
    }
    cout << "\n";
  }
}

void Configuration::randomize() {
  int swap_pos, temp;
  blank_pos = size*size - 1;
  for (int i = 0; i < size*size - 1; i++) {
    swap_pos = rand() % (size*size - i);
    temp = grid[i];
    grid[i] = grid[i + swap_pos];
    grid[i + swap_pos] = temp;
    if (grid[i] == 0) blank_pos = i;
  }
}

int Configuration::get_blank_row() {
  return blank_pos / size;
}

int Configuration::get_blank_col() {
  return blank_pos % size;
}

bool Configuration::is_solved() {
  for (int i=0; i<size*size; i++) {
    if (grid[i] != i) return false;
  }
  return true;
}

void Configuration::blank_left() {
  int row = get_blank_row();
  int col = get_blank_col();
  blank_pos = row*size + col - 1;
  int temp = grid[blank_pos];
  grid[blank_pos] = 0;
  grid[row*size + col] = temp;
}

void Configuration::blank_right() {
  int row = get_blank_row();
  int col = get_blank_col();
  blank_pos = row*size + col + 1;
  int temp = grid[blank_pos];
  grid[blank_pos] = 0;
  grid[row*size + col] = temp;
}

void Configuration::blank_up() {
  int row = get_blank_row();
  int col = get_blank_col();
  blank_pos = (row-1)*size + col;
  int temp = grid[blank_pos];
  grid[blank_pos] = 0;
  grid[row*size + col] = temp;
}

void Configuration::blank_down() {
  int row = get_blank_row();
  int col = get_blank_col();
  blank_pos = (row+1)*size + col;
  int temp = grid[blank_pos];
  grid[blank_pos] = 0;
  grid[row*size + col] = temp;
}

void print_path(Configuration *c) {
  if (c->get_parent() != NULL) {
    print_path(c->get_parent());
  }
  c->print();
  cout << "=====\n";
}
