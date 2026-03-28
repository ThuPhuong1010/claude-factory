When editing test files (*.test.*):
- Test behavior, not implementation
- describe('{Name}') → it('should {behavior} when {condition}')
- Must cover: happy path, error state, empty state
- Use userEvent over fireEvent
