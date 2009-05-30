class Configuration {
  public:
    Configuration(int in_size);
    Configuration(const Configuration &c);
    Configuration(Configuration *c);
    ~Configuration();
    Configuration *get_parent();
    void set_parent(Configuration *c);
    void print();
    void randomize();
    int get_blank_row();
    int get_blank_col();
    bool is_solved();
    void blank_left();
    void blank_right();
    void blank_up();
    void blank_down();
  protected:
    int blank_pos;
    int size;
    int *grid;
    Configuration *parent;
};

void print_path(Configuration *c);
